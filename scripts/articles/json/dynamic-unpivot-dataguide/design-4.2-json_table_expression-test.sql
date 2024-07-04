prompt design-4.2-json_table_expression-test.sql

column row#id format 99
column name format a10
column side format a10
column color format a10
column width format a10
column height format a10
column length format a10
column radius format a10
set null <null>

----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

select j.*
from 
    --json_table(:jdoc, '$[*]' 
    json_table(dynamic_json#test.test_jdoc(), '$[*]' 
        columns (
            "row#id" for ordinality
            , "name"     varchar2(4000) path '$.name'
            , "side"     varchar2(4000) path '$.side'
            , "color"    varchar2(4000) path '$.color'
            , "width"    varchar2(4000) path '$.width'
            , "height"   varchar2(4000) path '$.height'
            , "length"   varchar2(4000) path '$.length'
            , "radius"   varchar2(4000) path '$.radius'
        )
    ) j
/

----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

select j.*
from 
    --json_table(:jdoc, '$.my_shapes[*]' 
    json_table(dynamic_json#test.test_jdoc('nested'), '$.my_shapes[*]' 
        columns (
            "row#id" for ordinality
            , "name"     varchar2(4000) path '$.name'
            , "side"     varchar2(4000) path '$.side'
            , "color"    varchar2(4000) path '$.color'
            , "width"    varchar2(4000) path '$.width'
            , "height"   varchar2(4000) path '$.height'
            , "length"   varchar2(4000) path '$.length'
            , "radius"   varchar2(4000) path '$.radius'
        )
    ) j
/

/*
design-4.2-json_table_expression-test.sql

row#id name       side       color      width      height     length     radius    
------ ---------- ---------- ---------- ---------- ---------- ---------- ----------
     1 square     5          blue       <null>     <null>     <null>     <null>    
     2 rectangle  <null>     <null>     3          <null>     5          <null>    
     3 box        <null>     <null>     3          2          5          <null>    
     4 hexagon    3          red        <null>     <null>     <null>     <null>    
     5 circle     <null>     <null>     <null>     <null>     <null>     3         


row#id name       side       color      width      height     length     radius    
------ ---------- ---------- ---------- ---------- ---------- ---------- ----------
     1 square     5          blue       <null>     <null>     <null>     <null>    
     2 rectangle  <null>     <null>     3          <null>     5          <null>    
     3 box        <null>     <null>     3          2          5          <null>    
     4 hexagon    3          red        <null>     <null>     <null>     <null>    
     5 circle     <null>     <null>     <null>     <null>     <null>     3         


*/