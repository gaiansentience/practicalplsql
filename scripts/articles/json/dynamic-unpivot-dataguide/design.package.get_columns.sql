prompt design-4-dataguide-columns-collection.sql

--convert dataguide to column definitions using json table
--select into a collection that will be used to build a json table columns clause

declare
    l_json $if dbms_db_version.version >= 21 $then json $else clob $end;

    type t_column is record (
        col_name    varchar2(100), 
        datatype    varchar2(20), 
        column_path varchar2(100));
        
    type t_columns is table of t_column index by pls_integer;

    function dataguide_columns(
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
    end dataguide_columns;

    procedure print_dataguide_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end, 
        p_array_path in varchar2 default null)
    is
        c_space constant varchar2(1) := ' ';
        l_cols t_columns;        
    begin
        l_cols := dataguide_columns(p_jdoc, p_array_path);
        
        dbms_output.put_line('Column definitions from document dataguide.' 
            || case when p_array_path is not null then ' p_array_path => ' || p_array_path end );
        for i in $if dbms_db_version.version >= 21 $then indices of l_cols $else 1..l_cols.count $end loop
            dbms_output.put_line(
                'col_name => ' || l_cols(i).col_name
                || ', datatype => ' || l_cols(i).datatype
                || ', column_path => ' || l_cols(i).column_path);
        end loop;    
    end print_dataguide_columns;

begin

    l_json := design#dynamic_json.test_jdoc();
    print_dataguide_columns(l_json);
            
    l_json := design#dynamic_json.test_jdoc('nested');
    print_dataguide_columns(l_json, '.my_shapes');

end;
/

/*
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
*/