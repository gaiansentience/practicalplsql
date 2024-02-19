column plan_table_output format a130;
set pagesize 1000;

set autotrace traceonly explain
select * from row_compare_json(products_source, products_target, columns(product_id))
/

--notes
    --autotrace only shows the call to the macro

/*

Autotrace TraceOnly
 Exhibits the performance statistics with silent query output

10 rows selected. 


PLAN_TABLE_OUTPUT                                                                                                                 
----------------------------------------------------------------------------------------------------------------------------------
SQL_ID  c13y9136jjjzv, child number 0
-------------------------------------
select * from row_compare_json(products_source, products_target, 
columns(product_id))
 
Plan hash value: 320625626
 
---------------------------------------------------------------------------------------------------
| Id  | Operation                        | Name               | E-Rows |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |                    |        |       |       |          |
|   1 |  SORT ORDER BY                   |                    |     12 |  4096 |  4096 | 4096  (0)|
|   2 |   VIEW                           |                    |     12 |       |       |          |
|   3 |    UNION-ALL                     |                    |        |       |       |          |
|*  4 |     FILTER                       |                    |        |       |       |          |
|   5 |      MERGE JOIN OUTER            |                    |      6 |       |       |          |
|   6 |       TABLE ACCESS BY INDEX ROWID| PRODUCTS_SOURCE    |      6 |       |       |          |
|   7 |        INDEX FULL SCAN           | PRODUCTS_SOURCE_PK |      6 |       |       |          |
|*  8 |       FILTER                     |                    |        |       |       |          |
|*  9 |        SORT JOIN                 |                    |      6 |  2048 |  2048 | 2048  (0)|
|  10 |         TABLE ACCESS FULL        | PRODUCTS_TARGET    |      6 |       |       |          |
|  11 |     MERGE JOIN ANTI              |                    |      6 |       |       |          |
|  12 |      TABLE ACCESS BY INDEX ROWID | PRODUCTS_TARGET    |      6 |       |       |          |
|  13 |       INDEX FULL SCAN            | PRODUCTS_TARGET_PK |      6 |       |       |          |
|* 14 |      FILTER                      |                    |        |       |       |          |
|* 15 |       SORT JOIN                  |                    |      6 |  2048 |  2048 | 2048  (0)|
|  16 |        TABLE ACCESS FULL         | PRODUCTS_SOURCE    |      6 |       |       |          |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter("PRODUCTS_TARGET"."PRODUCT_ID" IS NULL)
   8 - filter(JSON_EQUAL2(JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_SOURCE"."PRODUCT_ID", 
              'CODE' VALUE "PRODUCTS_SOURCE"."CODE", 'NAME' VALUE "PRODUCTS_SOURCE"."NAME", 
              'DESCRIPTION' VALUE "PRODUCTS_SOURCE"."DESCRIPTION", 'STYLE' VALUE 
              "PRODUCTS_SOURCE"."STYLE", 'UNIT_MSRP' VALUE "PRODUCTS_SOURCE"."UNIT_MSRP" NULL ON NULL  
              RETURNING VARCHAR2(4000) FORMAT JSON ), JSON_OBJECT('PRODUCT_ID' VALUE 
              "PRODUCTS_TARGET"."PRODUCT_ID", 'CODE' VALUE "PRODUCTS_TARGET"."CODE", 'NAME' VALUE 
              "PRODUCTS_TARGET"."NAME", 'DESCRIPTION' VALUE "PRODUCTS_TARGET"."DESCRIPTION", 'STYLE' 
              VALUE "PRODUCTS_TARGET"."STYLE", 'UNIT_MSRP' VALUE "PRODUCTS_TARGET"."UNIT_MSRP" NULL ON 
              NULL  RETURNING VARCHAR2(4000) FORMAT JSON ))=1)
   9 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
       filter("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
  14 - filter(JSON_EQUAL2(JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_SOURCE"."PRODUCT_ID", 
              'CODE' VALUE "PRODUCTS_SOURCE"."CODE", 'NAME' VALUE "PRODUCTS_SOURCE"."NAME", 
              'DESCRIPTION' VALUE "PRODUCTS_SOURCE"."DESCRIPTION", 'STYLE' VALUE 
              "PRODUCTS_SOURCE"."STYLE", 'UNIT_MSRP' VALUE "PRODUCTS_SOURCE"."UNIT_MSRP" NULL ON NULL  
              RETURNING VARCHAR2(4000) FORMAT JSON ), JSON_OBJECT('PRODUCT_ID' VALUE 
              "PRODUCTS_TARGET"."PRODUCT_ID", 'CODE' VALUE "PRODUCTS_TARGET"."CODE", 'NAME' VALUE 
              "PRODUCTS_TARGET"."NAME", 'DESCRIPTION' VALUE "PRODUCTS_TARGET"."DESCRIPTION", 'STYLE' 
              VALUE "PRODUCTS_TARGET"."STYLE", 'UNIT_MSRP' VALUE "PRODUCTS_TARGET"."UNIT_MSRP" NULL ON 
              NULL  RETURNING VARCHAR2(4000) FORMAT JSON ))=1)
  15 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
       filter("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 

Statistics
-----------------------------------------------------------
               2  CPU used by this session
               2  CPU used when call started
               2  DB time
              32  Requests to/from client
              32  SQL*Net roundtrips to/from client
             941  buffer is not pinned count
              24  buffer is pinned count
             571  bytes received via SQL*Net from client
           60937  bytes sent via SQL*Net to client
             475  calls to get snapshot scn: kcmgss
               5  calls to kcmgcs
            1400  consistent gets
            1369  consistent gets examination
            1369  consistent gets examination (fastpath)
            1400  consistent gets from cache
              31  consistent gets pin
              31  consistent gets pin (fastpath)
               1  enqueue releases
               1  enqueue requests
              14  execute count
             454  index fetch by key
               9  index range scans
        11468800  logical read bytes from cache
              27  no work - consistent read gets
              37  non-idle wait count
              14  opened cursors cumulative
               1  opened cursors current
               1  parse count (hard)
              12  parse count (total)
               2  parse time cpu
               2  parse time elapsed
              73  recursive calls
               2  recursive cpu usage
             454  rows fetched via callback
              -2  session cursor cache count
              12  session cursor cache hits
            1400  session logical reads
               4  sorts (memory)
            1569  sorts (rows)
             476  table fetch by rowid
              10  table scan blocks gotten
              14  table scan disk non-IMC rows gotten
              14  table scan rows gotten
               2  table scans (short tables)
              33  user calls

*/