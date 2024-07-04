set feedback on
set pagesize 20
set null NULL

column id format 999
column key format a8
column value format a10

with json_document as (
    select
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
        ~' as jdoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document b,
        json_table(b.jdoc format json, '$.my_shapes[*]' 
            columns (
                "id"       for ordinality, 
                "name"     path '$.name',
                "color"    path '$.color',
                "side"     path '$.side',
                "length"   path '$.length',
                "width"    path '$.width',
                "height"   path '$.height',
                "radius"   path '$.radius'
            )
        ) j
)
select "id", "key", "value"
from 
    json_relational 
    unpivot (
        "value" for "key" in (
            "name", "color", "side", "length", "width", "height", "radius")
    ) 
order by "id", "key"
/

/*

  id key      value     
---- -------- ----------
   1 color    blue      
   1 name     square    
   1 side     5         
   2 length   5         
   2 name     rectangle 
   2 width    3         
   3 height   2         
   3 length   5         
   3 name     box       
   3 width    3         
   4 color    red       
   4 name     hexagon   
   4 side     3         
   5 name     circle    
   5 radius   3         

15 rows selected. 

*/