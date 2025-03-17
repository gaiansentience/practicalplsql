--1.3-alt-test-queries.sql

prompt show version for test
select banner_full from v$version;


prompt **********************
prompt plsql function 

explain plan for
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_basic(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_basic(n), 2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

prompt **********************
prompt plsql function - pragma udf

explain plan for 
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_udf(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_udf(n), 2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

prompt **********************
prompt plsql function - deterministic

explain plan for
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_deterministic(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_deterministic(n), 2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

alter session set sql_transpiler = on;

select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_deterministic(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_deterministic(n), 2) = 1
/

select * from dbms_xplan.display_cursor(format => 'BASIC +PREDICATE')
/


prompt **********************
prompt scalar macro function

explain plan for
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_macro(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_macro(n), 2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/


prompt **********************
prompt pure sql only

explain plan for
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select level * level as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( n * n, 2) = 1
/

select * from dbms_xplan.display(format => 'BASIC +PREDICATE')
/

prompt **********************
prompt test queries complete