--4.1-run-tests-timing-transpiler.sql

prompt compare timings for calling the functions from sql

prompt enable the sql transpiler
alter session set sql_transpiler = on;

prompt use set timing on to get basic timing
set timing on

@1.2-test-queries.sql;

set timing off
alter session set sql_transpiler = off;