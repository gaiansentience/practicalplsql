column data_guide format a5000
set long 5000
set pagesize 200

--row difference macro converts rows to json to use json_equal for the full outer join
--json_dataguide shows the keys used in these json objects
with row_json as (
    select json_object(*) as jdoc from products_source
    union all
    select json_object(*) as jdoc from products_target
)
select json_dataguide(jdoc)as data_guide
from row_json
/

/*


DATA_GUIDE (manually formatted)                                                                                         

[
    {"o:path":"$","type":"object","o:length":128},
    {"o:path":"$.CODE","type":"string","o:length":8},
    {"o:path":"$.MSRP","type":"number","o:length":2},
    {"o:path":"$.NAME","type":"string","o:length":32},
    {"o:path":"$.STYLE","type":"string","o:length":16},
    {"o:path":"$.PRODUCT_ID","type":"number","o:length":1},
    {"o:path":"$.DESCRIPTION","type":"string","o:length":32}
]

*/
with row_json as (
    select json_object(*) as jdoc from products_source
    union all
    select json_object(*) as jdoc from products_target
)
select 
    json_serialize(
        json_dataguide(jdoc)
    returning clob pretty) as data_guide
from row_json
/

/*

DATA_GUIDE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

[
  {
    "o:path" : "$",
    "type" : "object",
    "o:length" : 128
  },
  {
    "o:path" : "$.CODE",
    "type" : "string",
    "o:length" : 8
  },
  {
    "o:path" : "$.MSRP",
    "type" : "number",
    "o:length" : 2
  },
  {
    "o:path" : "$.NAME",
    "type" : "string",
    "o:length" : 32
  },
  {
    "o:path" : "$.STYLE",
    "type" : "string",
    "o:length" : 16
  },
  {
    "o:path" : "$.PRODUCT_ID",
    "type" : "number",
    "o:length" : 1
  },
  {
    "o:path" : "$.DESCRIPTION",
    "type" : "string",
    "o:length" : 32
  }
]

*/