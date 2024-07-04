prompt intro.unpivot_relational.sql

column id format 9
column cName format a11
column cValue format a20

set pagesize 100

prompt unpivot relational data requires datatype conversions

with base as (
    select 
        level * 10 as "c1_Number", 
        'details for ' || level * 10 as "c2_String",
        date '2024-06-01' + level as "c3_Date"
    from dual 
    connect by level <= 3
), base_to_common_datatype as (
    select 
        rownum as id, 
        to_char("c1_Number") as "c1_Number", 
        "c2_String", 
        to_char("c3_Date") as "c3_Date" 
    from base
), unpivot_base as (
    select id, "cName", "cValue"
    from
        base_to_common_datatype
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
 1 c3_Date     2024-06-02 00:00:00 
 2 c1_Number   20                  
 2 c2_String   details for 20      
 2 c3_Date     2024-06-03 00:00:00 
 3 c1_Number   30                  
 3 c2_String   details for 30      
 3 c3_Date     2024-06-04 00:00:00 

9 rows selected. 
*/

