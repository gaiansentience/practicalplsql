prompt query.json_doc.relational.sql


set null NULL
set feedback on

column id format 999
column name format a10
column color format a7
column side format 99
column length format 99
column width format 99
column height format 99
column radius format 99

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
                id       for ordinality, 
                name     path '$.name.string()',
                color    path '$.color.string()',
                side     path '$.side.number()',
                length   path '$.length.number()',
                width    path '$.width.number()',
                height   path '$.height.number()',
                radius   path '$.radius.number()'
            )
        ) j
)
select b.*
from json_relational b
/

/*

  ID NAME       COLOR   SIDE LENGTH WIDTH HEIGHT RADIUS
---- ---------- ------- ---- ------ ----- ------ ------
   1 square     blue       5 NULL   NULL  NULL   NULL  
   2 rectangle  NULL    NULL      5     3 NULL   NULL  
   3 box        NULL    NULL      5     3      2 NULL  
   4 hexagon    red        3 NULL   NULL  NULL   NULL  
   5 circle     NULL    NULL NULL   NULL  NULL        3

5 rows selected. 

*/