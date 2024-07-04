prompt design-1.2-test_jdoc-query.sql

--verify that the test json can be used in sql

set long 1000
set linesize 200
set pagesize 100

prompt simple format test json in sql

with json_document as (
    select dynamic_json#test.test_jdoc('simple') as jdoc
    from dual
)
select json_serialize(b.jdoc returning clob pretty) as jdoc
from json_document b
/

prompt nested format test json in sql

with json_document as (
    select dynamic_json#test.test_jdoc('nested') as jdoc
    from dual
)
select json_serialize(b.jdoc returning clob pretty) as jdoc
from json_document b
/


/*
design-1.2-test_jdoc-query.sql
simple format test json in sql

JDOC                                                                            
--------------------------------------------------------------------------------
[
  {
    "name" : "square",
    "side" : 5,
    "color" : "blue"
  },
  {
    "name" : "rectangle",
    "length" : 5,
    "width" : 3
  },
  {
    "name" : "box",
    "length" : 5,
    "width" : 3,
    "height" : 2
  },
  {
    "name" : "hexagon",
    "side" : 3,
    "color" : "red"
  },
  {
    "name" : "circle",
    "radius" : 3
  }
]


nested format test json in sql

JDOC                                                                            
--------------------------------------------------------------------------------
{
  "my_shapes" :
  [
    {
      "name" : "square",
      "side" : 5,
      "color" : "blue"
    },
    {
      "name" : "rectangle",
      "length" : 5,
      "width" : 3
    },
    {
      "name" : "box",
      "length" : 5,
      "width" : 3,
      "height" : 2
    },
    {
      "name" : "hexagon",
      "side" : 3,
      "color" : "red"
    },
    {
      "name" : "circle",
      "radius" : 3
    }
  ]
}

*/