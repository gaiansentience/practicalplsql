prompt design-3.1-any_dataguide.sql

set long 1000
set pagesize 100

prompt all flat dataguides have the same structure

prompt dataguide of dataguide for simple test document

with json_document as (
    select dynamic_json#test.test_jdoc('simple') as jdoc
    from dual
), document_dataguide as (
    select json_dataguide(jdoc) as jdg
    from json_document
), dataguide_dataguide as (
    select json_dataguide(jdg) as jdg
    from document_dataguide
)
select json_serialize(jdg returning clob pretty) as any_dataguide
from dataguide_dataguide;

prompt dataguide of dataguide for nested test document

with json_document as (
    select dynamic_json#test.test_jdoc('nested') as jdoc
    from dual
), document_dataguide as (
    select json_dataguide(jdoc) as jdg
    from json_document
), dataguide_dataguide as (
    select json_dataguide(jdg) as jdg
    from document_dataguide
)
select json_serialize(jdg returning clob pretty) as any_dataguide
from dataguide_dataguide;

/*

design-2.2-any_dataguide.sql
all flat dataguides have the same structure
dataguide of dataguide for simple test document

ANY_DATAGUIDE                                                                   
--------------------------------------------------------------------------------
[
  {
    "o:path" : "$",
    "type" : "array",
    "o:length" : 512
  },
  {
    "o:path" : "$.type",
    "type" : "string",
    "o:length" : 8
  },
  {
    "o:path" : "$.\"o:path\"",
    "type" : "string",
    "o:length" : 8
  },
  {
    "o:path" : "$.\"o:length\"",
    "type" : "number",
    "o:length" : 2
  }
]


dataguide of dataguide for nested test document

ANY_DATAGUIDE                                                                   
--------------------------------------------------------------------------------
[
  {
    "o:path" : "$",
    "type" : "array",
    "o:length" : 1024
  },
  {
    "o:path" : "$.type",
    "type" : "string",
    "o:length" : 8
  },
  {
    "o:path" : "$.\"o:path\"",
    "type" : "string",
    "o:length" : 32
  },
  {
    "o:path" : "$.\"o:length\"",
    "type" : "number",
    "o:length" : 2
  }
]

*/