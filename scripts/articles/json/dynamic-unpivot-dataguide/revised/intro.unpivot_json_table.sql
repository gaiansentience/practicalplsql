prompt intro.unpivot_json_table.sql

column id format 9
column cName format a11
column cValue format a20
set pagesize 100

prompt unpivot using json_table to convert datatypes

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
                "c1_Number" varchar2(50) path '$.c1_Number', 
                "c2_String" varchar2(50) path '$.c2_String',
                "c3_Date"   varchar2(50) path '$.c3_Date'
            )
        ) j 
), unpivot_base as (
    select id, "cName", "cValue"
    from
        json_to_relational
        unpivot (
            "cValue" for "cName" in (
                "c1_Number", "c2_String", "c3_Date"
                )
        )
)
select * from unpivot_base;

/*
ID cName       cValue              
-- ----------- --------------------
 1 c1_Number   10                  
 1 c2_String   details for 10      
 1 c3_Date     2024-06-02T00:00:00 
 2 c1_Number   20                  
 2 c2_String   details for 20      
 2 c3_Date     2024-06-03T00:00:00 
 3 c1_Number   30                  
 3 c2_String   details for 30      
 3 c3_Date     2024-06-04T00:00:00 

9 rows selected. 
*/

