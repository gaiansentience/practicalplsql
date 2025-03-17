--1.3-alt-test-queries.sql

prompt show version for test
select banner_full from v$version;


prompt **********************
prompt plsql function 
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_basic(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_basic(n), 2) = 1
/

prompt **********************
prompt plsql function - pragma udf
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_udf(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_udf(n), 2) = 1
/

prompt **********************
prompt plsql function - deterministic
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_deterministic(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_deterministic(n), 2) = 1
/

prompt **********************
prompt scalar macro function
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_macro(level) as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( f_macro(n), 2) = 1
/

prompt **********************
prompt pure sql only
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select level * level as n_sq2, level as n
    from dual
    connect by level <= 1000000
    )
where mod( n * n, 2) = 1
/

prompt **********************
prompt test queries complete