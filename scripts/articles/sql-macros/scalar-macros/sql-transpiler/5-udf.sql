--5-udf.sql

set pagesize 50;

create or replace function f(n in number) return number
is
    pragma udf;
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

/*
Predicate Information (identified by operation id):
 
   2 - filter(MOD("F"("N"),2)=1)
   3 - filter(LEVEL<=10)
*/