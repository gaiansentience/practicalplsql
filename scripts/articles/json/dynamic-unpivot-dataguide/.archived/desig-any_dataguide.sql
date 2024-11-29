prompt design-3-any_dataguide.sql

-- the dataguide has a standard structure
set long 1000
set pagesize 100

with json_document as (
    select design#dynamic_json.test_jdoc('nested') as jdoc
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

ANY_DATAGUIDE                                                                  

[
  {"o:path" : "$", "type" : "array", "o:length" : 1024},
  {"o:path" : "$.type", "type" : "string", "o:length" : 8},
  {"o:path" : "$.\"o:path\"", "type" : "string", "o:length" : 32},
  {"o:path" : "$.\"o:length\"", "type" : "number", "o:length" : 2}
]

*/