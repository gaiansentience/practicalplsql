prompt design.block.unpivot.sql

--build json_table_expression as CTE
--build unpivot expression using columns collection
--Test the resulting sql for unpivot syntax
--Substitute the actual json or dynamic_json.get_test_json
    
set serveroutput on
declare

    l_json $if dbms_db_version.version >= 21 $then json $else clob $end ;
    
    function local#build_unpivot_expression(
        p_cols in dynamic_json.t_columns,
        p_json_table_expression in varchar2
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_unpivot_cols varchar2(4000);
        c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    begin
    
        --build the unpivot expression using the columns collection
        for i in 1..p_cols.count loop
            l_unpivot_cols := l_unpivot_cols || c_indent
                || case when i > 1 then ', ' end 
                || p_cols(i).col_name || chr(10);
        end loop;
        l_unpivot_cols := rtrim(l_unpivot_cols, chr(10));


        l_sql := q'+
with json_to_relational as (
##JSON_TABLE_EXPRESSION##
)
select "id#ordinality", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
##UNPIVOT_COLUMNS##
            )
    ) 
order by "id#ordinality", "column#key"
+';

        l_sql := replace(l_sql, '##JSON_TABLE_EXPRESSION##', p_json_table_expression);
        l_sql := replace(l_sql, '##UNPIVOT_COLUMNS##', l_unpivot_cols);
        return l_sql;
    
    end local#build_unpivot_expression;

    procedure local#print_unpivot_expression(
        p_jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        p_array_path in varchar2 default null
    )
    is
        l_cols dynamic_json.t_columns;
        l_json_table_sql varchar2(4000);
        l_sql varchar2(4000);
    begin
        l_cols := dynamic_json.get_columns(p_jdoc, p_array_path);
        l_json_table_sql := dynamic_json.build_json_table_expression(l_cols, p_array_path);
        l_sql := local#build_unpivot_expression(l_cols, l_json_table_sql);
        dbms_output.put_line(l_sql);
    end local#print_unpivot_expression;
  
begin

    l_json := dynamic_json.get_test_json('simple');
    local#print_unpivot_expression(l_json, null);
            
    l_json := dynamic_json.get_test_json('nested');
    local#print_unpivot_expression(l_json, '.my_shapes');

end;
/

/*
with json_to_relational as (

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

)
select "id#ordinality", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
            "name"
            , "side"
            , "color"
            , "width"
            , "height"
            , "length"
            , "radius"
            )
    ) 
order by "id#ordinality", "column#key"


with json_to_relational as (

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

)
select "id#ordinality", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
            "name"
            , "side"
            , "color"
            , "width"
            , "height"
            , "length"
            , "radius"
            )
    ) 
order by "id#ordinality", "column#key"
*/