--1.5-compare-function-to-macro.sql

set pagesize 100
column plan_table_output format a80

create table if not exists test_increments as 
with base(n, i) as (
    values 
        (1.217, 1/4), (1.08, 1/4)
        , (13, 5), (11, 5)
        , (19, 12), (14, 12)
)
select 
    n as "number"
    , i as "increment"
from base;

prompt filter by round_increments_sqm, macro function call is not in predicates
explain plan for
select * from test_increments
where round_increments_sqm("number","increment") = 10;

select * 
from   dbms_xplan.display ( format => 'BASIC +PREDICATE' );

/*
Predicate Information (identified by operation id):
---------------------------------------------------
   5 - filter(ROUND("number"/"increment")*"increment"=10)
*/

prompt filter by round_increments, function call is in predicates with transpiler off
alter session set sql_transpiler = off;

explain plan for
select * from test_increments
where round_increments("number","increment") = 10;

select * 
from   dbms_xplan.display ( format => 'BASIC +PREDICATE' );

/*
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - filter("ROUND_INCREMENTS"("number","increment")=10)
*/

prompt filter by round_increments, function call is not in predicates with transpiler on
alter session set sql_transpiler = on;

explain plan for
select * from test_increments
where round_increments("number","increment") = 10;

select * 
from   dbms_xplan.display ( format => 'BASIC +PREDICATE' );

/*
Predicate Information (identified by operation id):
---------------------------------------------------
   5 - filter(ROUND("number"/"increment")*"increment"=10)
*/

alter session set sql_transpiler = off;
drop table if exists test_increments;