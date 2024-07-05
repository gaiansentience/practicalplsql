set feedback on

with json_shapes_doc as (
    select
        q'~
        {"my_shapes":
            [
                {"id":101,"type":"right-triangle","a":3,"b":4},
                {"id":102,"type":"square","side":5,"color":"blue"},
                {"id":103,"type":"rectangle","length":5,"width":3},            
                {"id":104,"type":"hexagon","side":3,"color":"red"},
                {"id":105,"type":"circle","radius":3},
            ]
        }
        ~' as jdoc
    from dual
), json_shape_rows as (
    select r.jshape
    from 
        json_shapes_doc b,
        json_table(b.jdoc format json, '$.my_shapes[*]' 
            columns (
                jshape clob format json path '$'
            )
        ) r
)
select b.jshape
from json_shape_rows b
/

/*


JSHAPE                                                                          
--------------------------------------------------------------------------------
{"id":101,"type":"right-triangle","a":3,"b":4}
{"id":102,"type":"square","side":5,"color":"blue"}
{"id":103,"type":"rectangle","length":5,"width":3}
{"id":104,"type":"hexagon","side":3,"color":"red"}
{"id":105,"type":"circle","radius":3}

*/