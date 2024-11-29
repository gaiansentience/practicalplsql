prompt intro.relational_data.sql

column id format 9
column c1_Number format 99
column c2_String format a15
set pagesize 100

with base as (
    select 
        level * 10 as "c1_Number", 
        'details for ' || level * 10 as "c2_String",
        date '2024-06-01' + level as "c3_Date"
    from dual 
    connect by level <= 3
)
select rownum as id, b.* from base b;

/*
ID c1_Number c2_String       c3_Date            
-- --------- --------------- -------------------
 1        10 details for 10  2024-06-02 00:00:00
 2        20 details for 20  2024-06-03 00:00:00
 3        30 details for 30  2024-06-04 00:00:00 
*/

