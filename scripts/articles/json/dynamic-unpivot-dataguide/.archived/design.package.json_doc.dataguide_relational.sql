prompt design.package.json_doc.dataguide_relational.sql

--convert dataguide to column definitions
--This will create valid column names and json path arguments for json_table column definitions
--Keep the datatype value to support generating a json_table expression with typed columns
--This can be used for a function to create a json_table query from any json_document

create or replace package dynamic_json
authid current_user
as

    type t_column is record (
        col_name    varchar2(100), 
        datatype    varchar2(20), 
        column_path varchar2(100));
        
    type t_columns is table of t_column index by pls_integer;

    function get_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        p_array_path in varchar2 default null
    ) return t_columns;
    
    procedure print_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        p_array_path in varchar2 default null);
        
    function get_test_json(p_structure in varchar2 default 'simple'
    ) return $if dbms_db_version.version < 21 $then clob $else json $end ;

    procedure print_test_json(p_structure in varchar2 default 'simple');

end dynamic_json;
/

create or replace package body dynamic_json 
as

    function get_columns(
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
    end get_columns;

    procedure print_columns(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end, 
        p_array_path in varchar2 default null)
    is
        c_space constant varchar2(1) := ' ';
        l_cols t_columns;        
    begin
        l_cols := get_columns(p_jdoc, p_array_path);
        
        dbms_output.put_line('Column definitions from document dataguide.' 
            || case when p_array_path is not null then ' p_array_path => ' || p_array_path end );
        for i in $if dbms_db_version.version >= 21 $then indices of l_cols $else 1..l_cols.count $end loop
            dbms_output.put_line(
                'col_name => ' || l_cols(i).col_name
                || ', datatype => ' || l_cols(i).datatype
                || ', column_path => ' || l_cols(i).column_path);
        end loop;    
    end print_columns;

    function get_test_json(p_structure in varchar2 default 'simple'
    ) return $if dbms_db_version.version < 21 $then clob $else json $end
    is
        l_json_text clob;
    begin
        if p_structure = 'simple' then
            l_json_text := to_clob(
                q'~
                [
                {"name":"square","side":5,"color":"blue"},
                {"name":"rectangle","length":5,"width":3},  
                {"name":"box","length":5,"width":3,"height":2},  
                {"name":"hexagon","side":3,"color":"red"},
                {"name":"circle","radius":3},
                ]
            ~');
        else
            l_json_text := to_clob(
                q'~
                {"my_shapes":
                    [
                    {"name":"square","side":5,"color":"blue"},
                    {"name":"rectangle","length":5,"width":3},  
                    {"name":"box","length":5,"width":3,"height":2},  
                    {"name":"hexagon","side":3,"color":"red"},
                    {"name":"circle","radius":3},
                    ]
                }
            ~');
        end if;
        
        return $if dbms_db_version.version < 21 $then l_json_text $else json(l_json_text) $end ;

    end get_test_json;
    
    procedure print_test_json(p_structure in varchar2 default 'simple')
    is
        l_jdoc $if dbms_db_version.version >= 21 $then json; $else clob; $end
    begin
        dbms_output.put_line('Test JSON Document: ' || p_structure);
        l_jdoc := get_test_json(p_structure);

$if dbms_db_version.version < 21 $then
        select json_serialize(l_jdoc returning clob pretty) 
        into l_jdoc from dual;
$end
        
        dbms_output.put_line($if dbms_db_version.version >= 21 $then json_serialize(l_jdoc pretty) $else l_jdoc $end);
    end print_test_json;

end dynamic_json;
/

set serveroutput on
declare
    l_json $if dbms_db_version.version >= 21 $then json $else clob $end;
begin

    l_json := dynamic_json.get_test_json('simple');
    dynamic_json.print_columns(l_json);
            
    l_json := dynamic_json.get_test_json('nested');
    dynamic_json.print_columns(l_json, '.my_shapes');

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