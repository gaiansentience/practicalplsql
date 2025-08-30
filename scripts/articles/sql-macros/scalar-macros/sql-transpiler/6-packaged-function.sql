--6-packaged-function.sql

set pagesize 50;

create or replace package p 
as

    function f(n in number) return number;

end p;
/

create or replace package body p
as

    function f(n in number) return number
    is
    begin
        return n * n;
    end f;

end p;
/

alter session set sql_transpiler = on;

explain plan for
select sum(p.f(n)) as odd_squares
from 
    (
    select level as n 
    from dual 
    connect by level <= 10
    )
where mod(p.f(n),2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

/*
Predicate Information (identified by operation id):
 
   3 - filter(MOD("N"*"N",2)=1)
   4 - filter(LEVEL<=10)
*/