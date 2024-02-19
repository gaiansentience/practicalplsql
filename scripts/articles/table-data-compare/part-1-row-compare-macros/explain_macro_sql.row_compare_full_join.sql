set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_full_join(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'ALL -ALIAS -PROJECTION')
/


--notes:  
--the predicates section shows that the decodes were converted to sys_op_map_nonnull calls
    
/*


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1669472241
 
------------------------------------------------------------------------------------------
| Id  | Operation              | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |                 |     2 |  8768 |    13   (8)| 00:00:01 |
|   1 |  SORT ORDER BY         |                 |     2 |  8768 |    13   (8)| 00:00:01 |
|   2 |   VIEW                 |                 |     2 |  8768 |    12   (0)| 00:00:01 |
|   3 |    UNION-ALL           |                 |       |       |            |          |
|*  4 |     FILTER             |                 |       |       |            |          |
|*  5 |      HASH JOIN OUTER   |                 |     1 |   183 |     6   (0)| 00:00:01 |
|   6 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |     6 |   540 |     3   (0)| 00:00:01 |
|   7 |       TABLE ACCESS FULL| PRODUCTS_TARGET |     6 |   558 |     3   (0)| 00:00:01 |
|*  8 |     HASH JOIN ANTI     |                 |     1 |   183 |     6   (0)| 00:00:01 |
|   9 |      TABLE ACCESS FULL | PRODUCTS_TARGET |     6 |   558 |     3   (0)| 00:00:01 |
|  10 |      TABLE ACCESS FULL | PRODUCTS_SOURCE |     6 |   540 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter("PRODUCTS_TARGET"."PRODUCT_ID" IS NULL)
   5 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID"(+) 
              AND "PRODUCTS_SOURCE"."CODE"="PRODUCTS_TARGET"."CODE"(+) AND 
              "PRODUCTS_SOURCE"."NAME"="PRODUCTS_TARGET"."NAME"(+) AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."DESCRIPTION")=SYS_OP_MAP_NONNULL("PRODUCTS_T
              ARGET"."DESCRIPTION"(+)) AND SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."STYLE")=SYS_OP_
              MAP_NONNULL("PRODUCTS_TARGET"."STYLE"(+)) AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."UNIT_MSRP")=SYS_OP_MAP_NONNULL("PRODUCTS_TAR
              GET"."UNIT_MSRP"(+)))
   8 - access("PRODUCTS_SOURCE"."PRODUCT_ID"="PRODUCTS_TARGET"."PRODUCT_ID" AND 
              "PRODUCTS_SOURCE"."CODE"="PRODUCTS_TARGET"."CODE" AND 
              "PRODUCTS_SOURCE"."NAME"="PRODUCTS_TARGET"."NAME" AND 
              SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."DESCRIPTION")=SYS_OP_MAP_NONNULL("PRODUCTS_T
              ARGET"."DESCRIPTION") AND SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."STYLE")=SYS_OP_MAP
              _NONNULL("PRODUCTS_TARGET"."STYLE") AND SYS_OP_MAP_NONNULL("PRODUCTS_SOURCE"."UNIT
              _MSRP")=SYS_OP_MAP_NONNULL("PRODUCTS_TARGET"."UNIT_MSRP"))
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2
---------------------------------------------------------------------------
 
   8 -  SEL$63477FE0
           -  INLINE
           -  INLINE
 
Note
-----
   - this is an adaptive plan

49 rows selected. 

*/