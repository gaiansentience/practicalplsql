prompt design-2.1-dataguide-test_jdoc.sql

set long 1000
set pagesize 100

prompt dataguide for simple test document

with json_document as (
    select dynamic_json#test.test_jdoc('simple') as jdoc
    from dual
)
select 
    json_serialize(json_dataguide(b.jdoc) returning clob pretty) as jdoc_dataguide
from json_document b
/

prompt dataguide for nested test document

with json_document as (
    select dynamic_json#test.test_jdoc('nested') as jdoc
    from dual
)
select 
    json_serialize(json_dataguide(b.jdoc) returning clob pretty) as jdoc_dataguide
from json_document b
/

/*

design-2.1-dataguide-test_jdoc.sql
dataguide for simple test document

JDOC_DATAGUIDE                                                                  
--------------------------------------------------------------------------------
[
  {
    "o:path" : "$",
    "type" : "array",
    "o:length" : 1
  },
  {
    "o:path" : "$.name",
    "type" : "string",
    "o:length" : 16
  },
  {
    "o:path" : "$.side",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.color",
    "type" : "string",
    "o:length" : 4
  },
  {
    "o:path" : "$.width",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.height",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.length",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.radius",
    "type" : "number",
    "o:length" : 2
  }
]


dataguide for nested test document

JDOC_DATAGUIDE                                                                  
--------------------------------------------------------------------------------
[
  {
    "o:path" : "$",
    "type" : "object",
    "o:length" : 1
  },
  {
    "o:path" : "$.my_shapes",
    "type" : "array",
    "o:length" : 1
  },
  {
    "o:path" : "$.my_shapes.name",
    "type" : "string",
    "o:length" : 16
  },
  {
    "o:path" : "$.my_shapes.side",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.my_shapes.color",
    "type" : "string",
    "o:length" : 4
  },
  {
    "o:path" : "$.my_shapes.width",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.my_shapes.height",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.my_shapes.length",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.my_shapes.radius",
    "type" : "number",
    "o:length" : 2
  }
]


*/