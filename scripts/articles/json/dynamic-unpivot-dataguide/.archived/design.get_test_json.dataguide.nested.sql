prompt design-dataguide-test_json-nested.sql

set long 1000
set pagesize 100

with json_document as (
    select dynamic_json.get_test_json('nested') as jdoc
    from dual
)
select 
    json_serialize(json_dataguide(b.jdoc) returning clob pretty) as jdoc_dataguide
from json_document b;

/*


JDOC_DATAGUIDE                                                                  

query.json_doc.dataguide.sql

JDOC_DATAGUIDE                                                                  
--------------------------------------------------------------------------------
[
  {"o:path" : "$", "type" : "object", "o:length" : 1},
  {"o:path" : "$.my_shapes", "type" : "array", "o:length" : 1},
  {"o:path" : "$.my_shapes.name", "type" : "string", "o:length" : 16},
  {"o:path" : "$.my_shapes.side", "type" : "number", "o:length" : 2},
  {"o:path" : "$.my_shapes.color", "type" : "string", "o:length" : 4},
  {"o:path" : "$.my_shapes.width", "type" : "number", "o:length" : 2},
  {"o:path" : "$.my_shapes.height", "type" : "number", "o:length" : 2},
  {"o:path" : "$.my_shapes.length", "type" : "number", "o:length" : 2},
  {"o:path" : "$.my_shapes.radius", "type" : "number", "o:length" : 2}
]

*/