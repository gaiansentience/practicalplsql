

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
), json_rows as (
    select r.jshape
    from 
        json_document b,
        json_table(b.jdoc format json, '$.my_shapes[*]' 
            columns (
                jshape clob format json path '$'
            )
        ) r
)
select b.jshape
from json_rows b
/

/*

JSHAPE                                                                          

{"name":"square","side":5,"color":"blue"}
{"name":"rectangle","length":5,"width":3}
{"name":"box","length":5,"width":3,"height":2}
{"name":"hexagon","side":3,"color":"red"}
{"name":"circle","radius":3}

5 rows selected. 

*/