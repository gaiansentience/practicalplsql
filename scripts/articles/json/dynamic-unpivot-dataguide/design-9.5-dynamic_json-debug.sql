prompt design--9.5-dynamic_json-debug.sql

set serveroutput on;

begin

    dynamic_json.debug_unpivot_json_array(
        jdoc => dynamic_json.test_jdoc(dynamic_json.c_array_simple),
        row_identifier => null,
        array_path => null,
        dataguide_columns => true,
        json_table_expression => true,
        unpivot_expression => true
    );
        
    dynamic_json.debug_unpivot_json_array(
        jdoc => dynamic_json.test_jdoc(dynamic_json.c_array_nested),
        row_identifier => null,
        array_path => '.my_shapes',
        dataguide_columns => true,
        json_table_expression => true,
        unpivot_expression => true
    );

    dynamic_json.debug_unpivot_json_array(
        jdoc => dynamic_json.test_jdoc(dynamic_json.c_array_simple_id),
        row_identifier => 'shape_id',
        array_path => null,
        dataguide_columns => true,
        json_table_expression => true,
        unpivot_expression => true
    );
        
    dynamic_json.debug_unpivot_json_array(
        jdoc => dynamic_json.test_jdoc(dynamic_json.c_array_nested_id),
        row_identifier => 'shape_id',
        array_path => '.my_shapes',
        dataguide_columns => true,
        json_table_expression => true,
        unpivot_expression => true
    );

end;
/

/*
design--9.5-dynamic_json-debug.sql
----------------------------------------------------------------------------------------------------
--Column definitions from document dataguide. no array path
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

----------------------------------------------------------------------------------------------------
--UNPIVOT Query generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" for ordinality
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
select "row#id", "column#key", "column#value"
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
order by "row#id", "column#key"

----------------------------------------------------------------------------------------------------
--Column definitions from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "row#id" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

----------------------------------------------------------------------------------------------------
--UNPIVOT Query generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "row#id" for ordinality
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
select "row#id", "column#key", "column#value"
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
order by "row#id", "column#key"

----------------------------------------------------------------------------------------------------
--Column definitions from document dataguide. no array path
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" number path '$.shape_id'
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

----------------------------------------------------------------------------------------------------
--UNPIVOT Query generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" number path '$.shape_id'
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
select "row#id", "column#key", "column#value"
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
order by "row#id", "column#key"

----------------------------------------------------------------------------------------------------
--Column definitions from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "row#id" number path '$.shape_id'
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

----------------------------------------------------------------------------------------------------
--UNPIVOT Query generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "row#id" number path '$.shape_id'
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
select "row#id", "column#key", "column#value"
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
order by "row#id", "column#key"



PL/SQL procedure successfully completed.


*/