prompt intro.json_dataguide.sql

column jDataguide format a50
set pagesize 100

prompt get json_dataguide for json document

with base as (
    select 
        level * 10 as "c1_Number", 
        'details for ' || level * 10 as "c2_String",
        date '2024-06-01' + level as "c3_Date"
    from dual 
    connect by level <= 3
), json_base as (
    select json_arrayagg(json_object(*) order by "c1_Number") as "jDoc" 
    from base
)
select json_serialize(json_dataguide("jDoc") pretty) as "jDataguide" 
from json_base;

/*
jDataguide                                        

[
  {"o:path" : "$", "type" : "array", "o:length" : 256},
  {"o:path" : "$.c3_Date", "type" : "string", "o:length" : 32},
  {"o:path" : "$.c1_Number", "type" : "number", "o:length" : 2},
  {"o:path" : "$.c2_String", "type" : "string", "o:length" : 16}
]
*/
