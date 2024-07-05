prompt design-7.2-test_jdoc-query.sql

--verify that the test json can be used in sql

set long 1000
set linesize 200
set pagesize 100

prompt simple plus id format test json in sql

with json_document as (
    select dynamic_json#test.test_jdoc('simple_id') as jdoc
    from dual
)
select json_serialize(b.jdoc returning clob pretty) as jdoc
from json_document b
/

prompt nested plus id format test json in sql

with json_document as (
    select dynamic_json#test.test_jdoc('nested_id') as jdoc
    from dual
)
select json_serialize(b.jdoc returning clob pretty) as jdoc
from json_document b
/

/*
design-7.2-test_jdoc-query.sql
simple plus id format test json in sql

JDOC                                                                            
--------------------------------------------------------------------------------
[
  {
    "shape_id" : 101,
    "name" : "square",
    "side" : 5,
    "color" : "blue"
  },
  {
    "shape_id" : 102,
    "name" : "rectangle",
    "length" : 5,
    "width" : 3
  },
  {
    "shape_id" : 103,
    "name" : "box",
    "length" : 5,
    "width" : 3,
    "height" : 2
  },
  {
    "shape_id" : 104,
    "name" : "hexagon",
    "side" : 3,
    "color" : "red"
  },
  {
    "shape_id" : 105,
    "name" : "circle",
    "radius" : 3
  }
]


nested plus id format test json in sql

JDOC                                                                            
--------------------------------------------------------------------------------
{
  "my_shapes" :
  [
    {
      "shape_id" : 101,
      "name" : "square",
      "side" : 5,
      "color" : "blue"
    },
    {
      "shape_id" : 102,
      "name" : "rectangle",
      "length" : 5,
      "width" : 3
    },
    {
      "shape_id" : 103,
      "name" : "box",
      "length" : 5,
      "width" : 3,
      "height" : 2
    },
    {
      "shape_id" : 104,
      "name" : "hexagon",
      "side" : 3,
      "color" : "red"
    },
    {
      "shape_id" : 105,
      "name" : "circle",
      "radius" : 3
    }
  ]
}



*/