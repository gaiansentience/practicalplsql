prompt intro.json_to_relational.sql

column id format 9
column c1_Number format 99
column c2_String format a15
set pagesize 100

prompt convert json array to relational data

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
), json_to_relational as (
    select j.id, j."c1_Number", j."c2_String", j."c3_Date"
    from 
        json_base b,
        json_table(b."jDoc", '$[*]' 
            columns(
                id for ordinality,  
                "c1_Number" number       path '$.c1_Number', 
                "c2_String" varchar2(50) path '$.c2_String',
                "c3_Date"   date         path '$.c3_Date'
            )
        ) j 
)
select * from json_to_relational;

/*
ID c1_Number c2_String       c3_Date            
-- --------- --------------- -------------------
 1        10 details for 10  2024-06-02 00:00:00
 2        20 details for 20  2024-06-03 00:00:00
 3        30 details for 30  2024-06-04 00:00:00
*/

