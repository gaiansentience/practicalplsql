column data_guide format a5000
set long 5000
set pagesize 200

--row difference macro returns json with differences
--use aggregate function json_dataguide to see the json_keys
select json_dataguide(jdoc)as data_guide
from row_compare_json_alt(products_source, products_target, columns(product_id, code))
/

/*


DATA_GUIDE (manually formatted)                                                                                         

[
    {"o:path":"$","type":"object","o:length":1},
    {"o:path":"$.CODE","type":"string","o:length":8},
    {"o:path":"$.MSRP","type":"number","o:length":2},
    {"o:path":"$.NAME","type":"string","o:length":32},
    {"o:path":"$.STYLE","type":"string","o:length":16},
    {"o:path":"$.PRODUCT_ID","type":"number","o:length":2},
    {"o:path":"$.DESCRIPTION","type":"string","o:length":32}
]

*/

select 
    json_serialize(
        json_dataguide(jdoc)
    returning clob pretty) as data_guide
from row_compare_json_alt(products_source, products_target, columns(product_id, code))
/

/*

DATA_GUIDE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

[
  {
    "o:path" : "$",
    "type" : "object",
    "o:length" : 1
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
    "o:length" : 2
  },
  {
    "o:path" : "$.DESCRIPTION",
    "type" : "string",
    "o:length" : 32
  }
]


*/