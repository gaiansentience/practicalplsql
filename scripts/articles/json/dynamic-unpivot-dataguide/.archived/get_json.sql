set long 1000
set pagesize 100

with json_shapes as (
    select
        q'~
        {"my_shapes":
            [
                {"id":1,"type":"right-triangle","a":3,"b":4},
                {"id":2,"type":"square","side":5,"color":"blue"},
                {"id":3,"type":"rectangle","length":5,"width":3},            
                {"id":4,"type":"hexagon","side":3,"color":"red"},
                {"id":5,"type":"circle","radius":3},
            ]
        }
        ~' as jdoc
    from dual
)
select 
    json_serialize(b.jdoc returning clob pretty) as jdoc
from json_shapes b
/


/*

JDOC                                                                            
--------------------------------------------------------------------------------
{
  "my_shapes" :
  [
    {
      "id" : 1,
      "type" : "right-triangle",
      "a" : 3,
      "b" : 4
    },
    {
      "id" : 2,
      "type" : "square",
      "side" : 5,
      "color" : "blue"
    },
    {
      "id" : 3,
      "type" : "rectangle",
      "length" : 5,
      "width" : 3
    },
    {
      "id" : 4,
      "type" : "hexagon",
      "side" : 3,
      "color" : "red"
    },
    {
      "id" : 5,
      "type" : "circle",
      "radius" : 3
    }
  ]
}

*/