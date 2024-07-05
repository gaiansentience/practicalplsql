prompt design.block.json_doc.dynamic_json_table_query.test.sql

prompt test the dynamic json table expression by replacing the bind variable 

column id#ordinality format 99
column name format a10
column side format a10
column color format a10
column width format a10
column height format a10
column length format a10
column radius format a10
set null (null)

with json_document as (
--    select :bindJson as jDoc
    select dynamic_json.test#get_json_document('simple') as jDoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document d,
        json_table(d.jdoc format json, '$[*]' 
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
select b.*
from json_relational b
/


with json_document as (
--    select :bindJson as jDoc
    select dynamic_json.test#get_json_document('nested') as jDoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document d,
        json_table(d.jdoc format json, '$.my_shapes[*]' 
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
select b.*
from json_relational b
/


/*
design.block.json_doc.dynamic_json_table_query.test.sql
test the dynamic json table expression by replacing the bind variable

id#ordinality name       side       color      width      height     length     radius    
------------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
            1 square     5          blue       (null)     (null)     (null)     (null)    
            2 rectangle  (null)     (null)     3          (null)     5          (null)    
            3 box        (null)     (null)     3          2          5          (null)    
            4 hexagon    3          red        (null)     (null)     (null)     (null)    
            5 circle     (null)     (null)     (null)     (null)     (null)     3         


id#ordinality name       side       color      width      height     length     radius    
------------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
            1 square     5          blue       (null)     (null)     (null)     (null)    
            2 rectangle  (null)     (null)     3          (null)     5          (null)    
            3 box        (null)     (null)     3          2          5          (null)    
            4 hexagon    3          red        (null)     (null)     (null)     (null)    
            5 circle     (null)     (null)     (null)     (null)     (null)     3         

*/