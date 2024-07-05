prompt design.package.unpivot.sql

--build json table expression with columns collection
--Test the resulting sql for json_table syntax
--Substitute the actual json or dynamic_json.get_test_json

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
        
    function build_json_table_expression(
        p_cols in t_columns,
        p_array_path in varchar2 default null
    ) return varchar2;

    procedure print_json_table_expression(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        p_array_path in varchar2 default null
    );
                
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

    function build_json_table_expression(
        p_cols in t_columns,
        p_array_path in varchar2 default null
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_json_table_cols varchar2(4000);
        c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    begin
    
        --build the columns expression
        --since we want to use this with unpivot, set all columns to varchar
        for i in 1..p_cols.count loop
            l_json_table_cols := l_json_table_cols || c_indent
                || ', ' || p_cols(i).col_name 
                || ' varchar2(4000)' 
                || ' path ''' || p_cols(i).column_path || '''' || chr(10);
        end loop;
        l_json_table_cols := rtrim(l_json_table_cols, chr(10));

        l_sql := q'+
select j.*
from 
    json_table(:jdoc, '$##ARRAY_PATH##[*]' 
        columns (
            "id#ordinality" for ordinality
##JSON_TABLE_COLUMNS##
        )
    ) j
+';

        l_sql := replace(l_sql, '##JSON_TABLE_COLUMNS##', l_json_table_cols);
        l_sql := replace(l_sql, '##ARRAY_PATH##', rtrim(p_array_path,'.'));
        return l_sql;
    
    end build_json_table_expression;

    procedure print_json_table_expression(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        p_array_path in varchar2 default null
    )
    is
        l_cols t_columns;
        l_sql varchar2(4000);
    begin
        l_cols := get_columns(p_jdoc, p_array_path);
        l_sql := build_json_table_expression(l_cols, p_array_path);
        dbms_output.put_line(l_sql);
    end print_json_table_expression;

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
    dynamic_json.print_json_table_expression(l_json);
            
    l_json := dynamic_json.get_test_json('nested');
    dynamic_json.print_json_table_expression(l_json, '.my_shapes');

end;
/

/*
select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j


select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j
*/