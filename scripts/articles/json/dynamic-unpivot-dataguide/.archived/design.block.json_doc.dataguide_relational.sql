prompt design.block.json_doc.dataguide_relational.sql

--convert dataguide to column definitions
--This will create valid column names and json path arguments for json_table column definitions
--Keep the datatype value to support generating a json_table expression with typed columns
--This can be used for a function to create a json_table query from any json_document

set serveroutput on
declare

    type t_column is record (
        col_name    varchar2(100), 
        datatype    varchar2(20), 
        column_path varchar2(100));
        
    type t_columns is table of t_column index by pls_integer;

    l_json $if dbms_db_version.version >= 21 $then json $else clob $end;

    function local#get_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        p_array_path in varchar2 default null
    ) return t_columns
    is
        l_column_definitions t_columns;
    begin    
        with dataguide as (
            select json_dataguide(p_jdoc) as jdoc_dataguide
            from dual
        ), dataguide_relational as (
            select 
                '"' || ltrim(replace(j.dg_path, p_array_path), '$.') || '"' as col_name,
                j.datatype,
                replace(j.dg_path, p_array_path) as column_path
            from 
                dataguide g,
                json_table(g.jdoc_dataguide, '$[*]'
                    columns(
                        dg_path path '$."o:path".string()',
                        datatype path '$.type.string()'
                    )
                ) j
        )
        select col_name, datatype, column_path
        bulk collect into l_column_definitions
        from dataguide_relational
        where datatype not in ('object', 'array');
        return l_column_definitions;
    end local#get_columns;

    procedure local#print_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end, 
        p_array_path in varchar2 default null)
    is
        c_space constant varchar2(1) := ' ';
        l_cols t_columns;        
    begin
        l_cols := local#get_columns(p_jdoc, p_array_path);
        
        dbms_output.put_line('Column definitions from document dataguide.' 
            || case when p_array_path is not null then ' p_array_path => ' || p_array_path end );
        for i in $if dbms_db_version.version >= 21 $then indices of l_cols $else 1..l_cols.count $end loop
            dbms_output.put_line(
                'col_name => ' || l_cols(i).col_name
                || ', datatype => ' || l_cols(i).datatype
                || ', column_path => ' || l_cols(i).column_path);
        end loop;    
    end local#print_columns;
    
begin

    l_json := dynamic_json.get_test_json('simple');
    local#print_columns(l_json);
            
    l_json := dynamic_json.get_test_json('nested');
    local#print_columns(l_json, '.my_shapes');

end;
/

/*
design.block.json_doc.dataguide_relational.sql

Column definitions from document dataguide.

col_name => "name", datatype => string, column_path => $.name
col_name => "side", datatype => number, column_path => $.side
col_name => "color", datatype => string, column_path => $.color
col_name => "width", datatype => number, column_path => $.width
col_name => "height", datatype => number, column_path => $.height
col_name => "length", datatype => number, column_path => $.length
col_name => "radius", datatype => number, column_path => $.radius

Column definitions from document dataguide. p_array_path => .my_shapes

col_name => "name", datatype => string, column_path => $.name
col_name => "side", datatype => number, column_path => $.side
col_name => "color", datatype => string, column_path => $.color
col_name => "width", datatype => number, column_path => $.width
col_name => "height", datatype => number, column_path => $.height
col_name => "length", datatype => number, column_path => $.length
col_name => "radius", datatype => number, column_path => $.radius


PL/SQL procedure successfully completed.
*/