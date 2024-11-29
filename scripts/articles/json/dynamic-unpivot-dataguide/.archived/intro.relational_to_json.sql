prompt intro.relational_to_json.sql

column jDoc format a40
set pagesize 100

prompt convert relational data to array of json objects

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
select json_serialize("jDoc" pretty) as "jDoc" 
from json_base;

/*
jDoc                                    

[
  {"c1_Number" : 10, "c2_String" : "details for 10", "c3_Date" : "2024-06-02T00:00:00"},
  {"c1_Number" : 20, "c2_String" : "details for 20", "c3_Date" : "2024-06-03T00:00:00"},
  {"c1_Number" : 30, "c2_String" : "details for 30", "c3_Date" : "2024-06-04T00:00:00"}
]
*/

