set feedback on
set long 1000
set pagesize 100

with json_document as (
    select
        q'~
        [
        {"name":"square","side":5,"color":"blue"},
        {"name":"rectangle","length":5,"width":3},  
        {"name":"box","length":5,"width":3,"height":2},  
        {"name":"hexagon","side":3,"color":"red"},
        {"name":"circle","radius":3},
        ]
        ~' as jdoc
    from dual
)
select 
    json_serialize(
        json_dataguide(b.jdoc) 
        returning clob pretty
    ) as jdoc_dataguide
from json_document b
/


/*

JDOC_DATAGUIDE                                                                  

[
  {
    "o:path" : "$",
    "type" : "array",
    "o:length" : 256
  },
  {
    "o:path" : "$.name",
    "type" : "string",
    "o:length" : 16
  },
  {
    "o:path" : "$.side",
    "type" : "number",
    "o:length" : 1
  },
  {
    "o:path" : "$.color",
    "type" : "string",
    "o:length" : 4
  },
  {
    "o:path" : "$.width",
    "type" : "number",
    "o:length" : 1
  },
  {
    "o:path" : "$.height",
    "type" : "number",
    "o:length" : 1
  },
  {
    "o:path" : "$.length",
    "type" : "number",
    "o:length" : 1
  },
  {
    "o:path" : "$.radius",
    "type" : "number",
    "o:length" : 1
  }
]

*/