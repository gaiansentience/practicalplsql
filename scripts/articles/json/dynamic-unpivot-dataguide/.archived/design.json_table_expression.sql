prompt design.block.json_table_expression.sql

--build json table expression with columns collection
--Test the resulting sql for json_table syntax
--Substitute the actual json or dynamic_json.get_test_json
    

set serveroutput on
declare

    l_json $if dbms_db_version.version >= 21 $then json $else clob $end ;
    
    function local#build_json_table_expression(
        p_cols in dynamic_json.t_columns,
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
    
    end local#build_json_table_expression;

    procedure local#print_json_table_expression(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        p_array_path in varchar2 default null
    )
    is
        l_cols dynamic_json.t_columns;
        l_sql varchar2(4000);
    begin
        l_cols := dynamic_json.get_columns(p_jdoc, p_array_path);
        l_sql := local#build_json_table_expression(l_cols, p_array_path);
        dbms_output.put_line(l_sql);
    end local#print_json_table_expression;
  
begin

    l_json := dynamic_json.get_test_json('nested');
    local#print_json_table_expression(l_json, null);
            
    l_json := dynamic_json.get_test_json('nested');
    local#print_json_table_expression(l_json, '.my_shapes');

end;
/

/*
select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "id#ordinality" for ordinality
            , "my_shapes.name" varchar2(4000) path '$.my_shapes.name'
            , "my_shapes.side" varchar2(4000) path '$.my_shapes.side'
            , "my_shapes.color" varchar2(4000) path '$.my_shapes.color'
            , "my_shapes.width" varchar2(4000) path '$.my_shapes.width'
            , "my_shapes.height" varchar2(4000) path '$.my_shapes.height'
            , "my_shapes.length" varchar2(4000) path '$.my_shapes.length'
            , "my_shapes.radius" varchar2(4000) path '$.my_shapes.radius'
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