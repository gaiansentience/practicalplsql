--5.1-run-tests-autotrace-transpiler.sql

prompt disable the sql transpiler (default session setting)
alter session set sql_transpiler = off;

@1.3-alt-test-queries-explained.sql;


prompt enable the sql transpiler
alter session set sql_transpiler = on;

@1.3-alt-test-queries-explained.sql;


alter session set sql_transpiler = off;
