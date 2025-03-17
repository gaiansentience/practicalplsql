--3.2-run-alt-tests-autotrace.sql

prompt compare statistics for calling the functions from sql

prompt use autotrace to get more execution information
alter session set statistics_level = 'ALL';

set autotrace traceonly statistics

@1.3-alt-test-queries.sql

set autotrace off