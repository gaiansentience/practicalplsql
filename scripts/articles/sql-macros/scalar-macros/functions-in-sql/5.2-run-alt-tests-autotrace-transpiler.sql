--5.1-run-tests-autotrace-transpiler.sql

prompt compare statistics for calling the functions from sql

prompt enable the sql transpiler
alter session set sql_transpiler = on;

prompt use autotrace to get more execution information
alter session set statistics_level = 'ALL';

set autotrace traceonly explain

@1.3-alt-test-queries.sql;

set autotrace off

alter session set sql_transpiler = off;
