prompt design-1-test_jdoc-simple.sql

set long 1000
set linesize 200
set pagesize 100

with json_document as (
    select design#dynamic_json.test_json('simple') as jdoc
    from dual
)
select json_serialize(b.jdoc returning clob pretty) as jdoc
from json_document b;

/*
JDOC                                                                            

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


1 row selected. 


*/