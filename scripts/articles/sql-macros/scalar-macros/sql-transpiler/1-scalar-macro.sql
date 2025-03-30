--1-scalar-macro.sql

set pagesize 50;

create or replace function f(n in number) return varchar2
sql_macro(scalar)
is
begin
    return 'n * n';
end f;
/

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

/*
Predicate Information (identified by operation id):
 
   3 - filter(MOD("N"*"N",2)=1)
   4 - filter(LEVEL<=10)
*/

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
Elapsed: 00:00:00.377
*/
