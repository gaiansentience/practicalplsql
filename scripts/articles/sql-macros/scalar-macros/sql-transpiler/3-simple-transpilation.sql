--3-simple-transpilation.sql

set pagesize 50;

create or replace function f(n in number) return number
is
begin
    return n * n;
end f;
/

alter session set sql_transpiler = on;

explain plan for
select sum(f(n)) as odd_squares
from 
    (
    select level as n 
    from dual 
    connect by level <= 10
    )
where mod(f(n),2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

set timing on;
select /*+ no_result_cache */ sum(f(n)) as odd_squares
from 
    (
    select level as n 
    from dual 
    connect by level <= 1e6
    )
where mod(f(n),2) = 1
/
set timing off;

/*
Predicate Information (identified by operation id):
 
   3 - filter(MOD("N"*"N",2)=1)
   4 - filter(LEVEL<=10)
*/

/*
Elapsed: 00:00:00.026
*/