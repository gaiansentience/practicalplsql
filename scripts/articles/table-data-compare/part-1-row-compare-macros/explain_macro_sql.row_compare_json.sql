set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_json(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'ALL -ALIAS -PROJECTION')
/


--notes:  
    
/*


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 320625626
 
-------------------------------------------------------------------------------------------------------
| Id  | Operation                        | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |                    |    12 | 48552 |    13  (24)| 00:00:01 |
|   1 |  SORT ORDER BY                   |                    |    12 | 48552 |    13  (24)| 00:00:01 |
|   2 |   VIEW                           |                    |    12 | 48552 |    12  (17)| 00:00:01 |
|   3 |    UNION-ALL                     |                    |       |       |            |          |
|*  4 |     FILTER                       |                    |       |       |            |          |
|   5 |      MERGE JOIN OUTER            |                    |     6 |  1098 |     6  (17)| 00:00:01 |
|   6 |       TABLE ACCESS BY INDEX ROWID| PRODUCTS_SOURCE    |     6 |   540 |     2   (0)| 00:00:01 |
|   7 |        INDEX FULL SCAN           | PRODUCTS_SOURCE_PK |     6 |       |     1   (0)| 00:00:01 |
|*  8 |       FILTER                     |                    |       |       |            |          |
|*  9 |        SORT JOIN                 |                    |     6 |   558 |     4  (25)| 00:00:01 |
|  10 |         TABLE ACCESS FULL        | PRODUCTS_TARGET    |     6 |   558 |     3   (0)| 00:00:01 |
|  11 |     MERGE JOIN ANTI              |                    |     6 |  1098 |     6  (17)| 00:00:01 |
|  12 |      TABLE ACCESS BY INDEX ROWID | PRODUCTS_TARGET    |     6 |   558 |     2   (0)| 00:00:01 |
|  13 |       INDEX FULL SCAN            | PRODUCTS_TARGET_PK |     6 |       |     1   (0)| 00:00:01 |
|* 14 |      FILTER                      |                    |       |       |            |          |
|* 15 |       SORT JOIN                  |                    |     6 |   540 |     4  (25)| 00:00:01 |
|  16 |        TABLE ACCESS FULL         | PRODUCTS_SOURCE    |     6 |   540 |     3   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter("PRODUCTS_TARGET"."PRODUCT_ID" IS NULL)
   8 - filter(JSON_EQUAL2(JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_SOURCE"."PRODUCT_ID", 
              'CODE' VALUE "PRODUCTS_SOURCE"."CODE", 'NAME' VALUE "PRODUCTS_SOURCE"."NAME", 'DESCRIPTION' 
              VALUE "PRODUCTS_SOURCE"."DESCRIPTION", 'STYLE' VALUE "PRODUCTS_SOURCE"."STYLE", 'UNIT_MSRP' 
              VALUE "PRODUCTS_SOURCE"."UNIT_MSRP" NULL ON NULL  RETURNING VARCHAR2(4000) FORMAT JSON ), 
              JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_TARGET"."PRODUCT_ID"(+), 'CODE' VALUE 
              "PRODUCTS_TARGET"."CODE"(+), 'NAME' VALUE "PRODUCTS_TARGET"."NAME"(+), 'DESCRIPTION' VALUE 
              "PRODUCTS_TARGET"."DESCRIPTION"(+), 'STYLE' VALUE "PRODUCTS_TARGET"."STYLE"(+), 'UNIT_MSRP' 
              VALUE "PRODUCTS_TARGET"."UNIT_MSRP"(+) NULL ON NULL  RETURNING VARCHAR2(4000) FORMAT JSON ))=1)
   9 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID"(+))
       filter("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID"(+))
  14 - filter(JSON_EQUAL2(JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_SOURCE"."PRODUCT_ID", 
              'CODE' VALUE "PRODUCTS_SOURCE"."CODE", 'NAME' VALUE "PRODUCTS_SOURCE"."NAME", 'DESCRIPTION' 
              VALUE "PRODUCTS_SOURCE"."DESCRIPTION", 'STYLE' VALUE "PRODUCTS_SOURCE"."STYLE", 'UNIT_MSRP' 
              VALUE "PRODUCTS_SOURCE"."UNIT_MSRP" NULL ON NULL  RETURNING VARCHAR2(4000) FORMAT JSON ), 
              JSON_OBJECT('PRODUCT_ID' VALUE "PRODUCTS_TARGET"."PRODUCT_ID", 'CODE' VALUE 
              "PRODUCTS_TARGET"."CODE", 'NAME' VALUE "PRODUCTS_TARGET"."NAME", 'DESCRIPTION' VALUE 
              "PRODUCTS_TARGET"."DESCRIPTION", 'STYLE' VALUE "PRODUCTS_TARGET"."STYLE", 'UNIT_MSRP' VALUE 
              "PRODUCTS_TARGET"."UNIT_MSRP" NULL ON NULL  RETURNING VARCHAR2(4000) FORMAT JSON ))=1)
  15 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
       filter("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID")
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2 (U - Unused (1))
---------------------------------------------------------------------------
 
  11 -  SEL$80F2CEF2
         U -  INLINE / hint overridden by another in parent query block
           -  INLINE

56 rows selected. 

*/