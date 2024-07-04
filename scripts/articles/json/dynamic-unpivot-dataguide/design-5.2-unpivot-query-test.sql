prompt design-5.2-unpivot-query-test.sql

column row#id format 9
column column#key format a10
column column#value format a20
set pagesize 100

----------------------------------------------------------------------------------------------------
prompt UNPIVOT Query generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    --json_table(:jdoc, '$[*]' 
    json_table(dynamic_json#test.test_jdoc('simple'), '$[*]' 

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
/
----------------------------------------------------------------------------------------------------
prompt UNPIVOT Query generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

with json_to_relational as (

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
/

/*
design-5.2-unpivot-query-test.sql
UNPIVOT Query generated from document dataguide. no array path

row#id column#key column#value        
------ ---------- --------------------
     1 color      blue                
     1 name       square              
     1 side       5                   
     2 length     5                   
     2 name       rectangle           
     2 width      3                   
     3 height     2                   
     3 length     5                   
     3 name       box                 
     3 width      3                   
     4 color      red                 
     4 name       hexagon             
     4 side       3                   
     5 name       circle              
     5 radius     3                   

15 rows selected. 

UNPIVOT Query generated from document dataguide. array_path => .my_shapes

row#id column#key column#value        
------ ---------- --------------------
     1 color      blue                
     1 name       square              
     1 side       5                   
     2 length     5                   
     2 name       rectangle           
     2 width      3                   
     3 height     2                   
     3 length     5                   
     3 name       box                 
     3 width      3                   
     4 color      red                 
     4 name       hexagon             
     4 side       3                   
     5 name       circle              
     5 radius     3                   

15 rows selected. 

*/