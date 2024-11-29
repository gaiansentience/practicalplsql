prompt design-2-dataguide-test_jdoc-simple.sql

set long 1000
set pagesize 100

with json_document as (
    select design#dynamic_json.test_jdoc() as jdoc
    from dual
)
select 
    json_serialize(json_dataguide(b.jdoc) returning clob pretty) as jdoc_dataguide
from json_document b
/


/*

JDOC_DATAGUIDE                                                                  

[
  {"o:path" : "$", "type" : "array", "o:length" : 1},
  {"o:path" : "$.name", "type" : "string", "o:length" : 16},
  {"o:path" : "$.side", "type" : "number", "o:length" : 2},
  {"o:path" : "$.color", "type" : "string", "o:length" : 4},
  {"o:path" : "$.width", "type" : "number", "o:length" : 2},
  {"o:path" : "$.height", "type" : "number", "o:length" : 2},
  {"o:path" : "$.length", "type" : "number", "o:length" : 2},
  {"o:path" : "$.radius", "type" : "number", "o:length" : 2}
]

*/