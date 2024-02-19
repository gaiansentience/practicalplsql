column plan_table_output format a130;
set pagesize 1000;

set autotrace traceonly explain
select * from row_compare_union_cte(products_source, products_target, columns(product_id))
/

--notes
    --autotrace only shows the call to the macro
    --the explain plan shows the materialized CTE expressions
/*
Autotrace TraceOnly
 Exhibits the performance statistics with silent query output

10 rows selected. 


PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------------------------------------
SQL_ID  7xbkvrn23nfnc, child number 0
-------------------------------------
select * from row_compare_union_cte(products_source, products_target, 
columns(product_id))
 
Plan hash value: 2482291778
 
--------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                 | Name                       | E-Rows |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                          |                            |        |       |       |          |
|   1 |  VIEW                                     |                            |     12 |       |       |          |
|   2 |   TEMP TABLE TRANSFORMATION               |                            |        |       |       |          |
|   3 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6717_DD6BD2C |        |  1024 |  1024 |          |
|   4 |     TABLE ACCESS FULL                     | PRODUCTS_SOURCE            |      6 |       |       |          |
|   5 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6718_DD6BD2C |        |  1024 |  1024 |          |
|   6 |     TABLE ACCESS FULL                     | PRODUCTS_TARGET            |      6 |       |       |          |
|   7 |    SORT ORDER BY                          |                            |     12 |  2048 |  2048 | 2048  (0)|
|   8 |     VIEW                                  |                            |     12 |       |       |          |
|   9 |      UNION-ALL                            |                            |        |       |       |          |
|  10 |       MINUS HASH                          |                            |        |   683K|   683K|          |
|  11 |        VIEW                               |                            |      6 |       |       |          |
|  12 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6717_DD6BD2C |      6 |       |       |          |
|  13 |        VIEW                               |                            |      6 |       |       |          |
|  14 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6718_DD6BD2C |      6 |       |       |          |
|  15 |       MINUS HASH                          |                            |        |   683K|   683K|          |
|  16 |        VIEW                               |                            |      6 |       |       |          |
|  17 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6718_DD6BD2C |      6 |       |       |          |
|  18 |        VIEW                               |                            |      6 |       |       |          |
|  19 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6717_DD6BD2C |      6 |       |       |          |
--------------------------------------------------------------------------------------------------------------------
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 

Statistics
-----------------------------------------------------------
              32  Requests to/from client
              32  SQL*Net roundtrips to/from client
              12  buffer is not pinned count
             576  bytes received via SQL*Net from client
           60072  bytes sent via SQL*Net to client
               4  calls to get snapshot scn: kcmgss
               4  calls to kcmgcs
              12  consistent gets
              12  consistent gets from cache
              12  consistent gets pin
              12  consistent gets pin (fastpath)
               2  execute count
           98304  logical read bytes from cache
              10  no work - consistent read gets
              32  non-idle wait count
               2  opened cursors cumulative
               1  opened cursors current
               2  parse count (total)
              -1  session cursor cache count
               2  session cursor cache hits
              12  session logical reads
               2  sorts (memory)
            1555  sorts (rows)
              10  table scan blocks gotten
              14  table scan disk non-IMC rows gotten
              14  table scan rows gotten
               2  table scans (short tables)
              33  user calls

*/