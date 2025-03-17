--1.2-test-queries.sql

prompt show version for test
select banner_full from v$version;

prompt **********************
prompt inline with function 

with function with_f_basic(
    n in number
) return number
is
begin 
    return n * n; 
end with_f_basic;

select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select with_f_basic(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt plsql function 
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_basic(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt inline with function - pragma udf
with function with_f_udf(
    n in number
) return number
is
    pragma udf;
begin 
    return n * n; 
end with_f_udf;

select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select with_f_udf(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt plsql function - pragma udf
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_udf(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt inline with function - deterministic 
with function with_f_deterministic(
    n in number
) return number deterministic
is
begin 
    return n * n; 
end with_f_deterministic;

select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select with_f_deterministic(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt plsql function - deterministic
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_deterministic(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt inline with function - scalar macro
with
function with_f_macro(
    n in number
) return varchar2 sql_macro(scalar)
is
begin 
    return 'n * n'; 
end with_f_macro;

select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select with_f_macro(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt scalar macro function
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select f_macro(level) as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt pure sql only
select /*+ no_result_cache */ sum(n_sq2)
from 
    (
    select level * level as n_sq2
    from dual
    connect by level <= 1000000
    )
/

prompt **********************
prompt test queries complete