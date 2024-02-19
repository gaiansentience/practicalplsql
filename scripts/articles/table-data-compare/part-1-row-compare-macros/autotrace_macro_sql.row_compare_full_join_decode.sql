column plan_table_output format a130;
set pagesize 1000;

set autotrace traceonly explain
select * from row_compare_full_join_decode(products_source, products_target, columns(product_id))
/

--notes
    --autotrace only shows the call to the macro
    --predicates section of plan shows decode joins were converted to sys_op_map_nonnull
/*

Autotrace TraceOnly
 Exhibits the performance statistics with silent query output

10 rows selected. 


PLAN_TABLE_OUTPUT                                                                                                                 
----------------------------------------------------------------------------------------------------------------------------------
SQL_ID  cmvh27sp6fc5r, child number 0
-------------------------------------
select * from row_compare_full_join(products_source, products_target, 
columns(product_id))
 
Plan hash value: 1669472241
 
--------------------------------------------------------------------------------------
| Id  | Operation              | Name            | E-Rows |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |                 |        |       |       |          |
|   1 |  SORT ORDER BY         |                 |      2 |  2048 |  2048 | 2048  (0)|
|   2 |   VIEW                 |                 |      2 |       |       |          |
|   3 |    UNION-ALL           |                 |        |       |       |          |
|*  4 |     FILTER             |                 |        |       |       |          |
|*  5 |      HASH JOIN OUTER   |                 |      1 |   814K|   814K| 1018K (0)|
|   6 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |      6 |       |       |          |
|   7 |       TABLE ACCESS FULL| PRODUCTS_TARGET |      6 |       |       |          |
|*  8 |     HASH JOIN ANTI     |                 |      1 |   810K|   810K|  770K (0)|
|   9 |      TABLE ACCESS FULL | PRODUCTS_TARGET |      6 |       |       |          |
|  10 |      TABLE ACCESS FULL | PRODUCTS_SOURCE |      6 |       |       |          |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter("PRODUCTS_TARGET"."PRODUCT_ID" IS NULL)
   5 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID" 
              AND "PRODUCTS_SOURCE"."CODE"="PRODUCTS_TARGET"."CODE" AND 
              "PRODUCTS_SOURCE"."NAME"="PRODUCTS_TARGET"."NAME" AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."DESCRIPTION")=SYS_OP_MAP_NONNULL("PRODUC
              TS_TARGET"."DESCRIPTION") AND SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."STYLE")=SY
              S_OP_MAP_NONNULL("PRODUCTS_TARGET"."STYLE") AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."UNIT_MSRP")=SYS_OP_MAP_NONNULL("PRODUCTS
              _TARGET"."UNIT_MSRP"))
   8 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID" 
              AND "PRODUCTS_SOURCE"."CODE"="PRODUCTS_TARGET"."CODE" AND 
              "PRODUCTS_SOURCE"."NAME"="PRODUCTS_TARGET"."NAME" AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."DESCRIPTION")=SYS_OP_MAP_NONNULL("PRODUC
              TS_TARGET"."DESCRIPTION") AND SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."STYLE")=SY
              S_OP_MAP_NONNULL("PRODUCTS_TARGET"."STYLE") AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."UNIT_MSRP")=SYS_OP_MAP_NONNULL("PRODUCTS
              _TARGET"."UNIT_MSRP"))
 
Note
-----
   - this is an adaptive plan
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 

Statistics
-----------------------------------------------------------
              32  Requests to/from client
              32  SQL*Net roundtrips to/from client
               8  buffer is not pinned count
               2  buffer is pinned count
             576  bytes received via SQL*Net from client
           60069  bytes sent via SQL*Net to client
               2  calls to get snapshot scn: kcmgss
               6  calls to kcmgcs
              24  consistent gets
              24  consistent gets from cache
              24  consistent gets pin
              24  consistent gets pin (fastpath)
               2  execute count
          196608  logical read bytes from cache
              20  no work - consistent read gets
              32  non-idle wait count
               2  opened cursors cumulative
               1  opened cursors current
               2  parse count (total)
              -1  session cursor cache count
               2  session cursor cache hits
              24  session logical reads
               2  sorts (memory)
            1555  sorts (rows)
              20  table scan blocks gotten
              28  table scan disk non-IMC rows gotten
              28  table scan rows gotten
               4  table scans (short tables)
              33  user calls

*/