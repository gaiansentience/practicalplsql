set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_union_cte(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'ALL -ALIAS -PROJECTION')
/

--notes:  
--the plan shows the materialization of the first two cte expressions (just like using this query directly)
--in contrast to the explain plan for the actual query, the hint report shows the hints as unused

/*


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2482291778
 
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                 | Name                       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                          |                            |    12 | 26304 |    15   (7)| 00:00:01 |
|   1 |  VIEW                                     |                            |    12 | 26304 |    15   (7)| 00:00:01 |
|   2 |   TEMP TABLE TRANSFORMATION               |                            |       |       |            |          |
|   3 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6727_DD6BD2C |       |       |            |          |
|   4 |     TABLE ACCESS FULL                     | PRODUCTS_SOURCE            |     6 |   540 |     3   (0)| 00:00:01 |
|   5 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6728_DD6BD2C |       |       |            |          |
|   6 |     TABLE ACCESS FULL                     | PRODUCTS_TARGET            |     6 |   558 |     3   (0)| 00:00:01 |
|   7 |    SORT ORDER BY                          |                            |    12 | 26304 |     9  (12)| 00:00:01 |
|   8 |     VIEW                                  |                            |    12 | 26304 |     8   (0)| 00:00:01 |
|   9 |      UNION-ALL                            |                            |       |       |            |          |
|  10 |       MINUS HASH                          |                            |       |       |            |          |
|  11 |        VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  12 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6727_DD6BD2C |     6 |   540 |     2   (0)| 00:00:01 |
|  13 |        VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  14 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6728_DD6BD2C |     6 |   558 |     2   (0)| 00:00:01 |
|  15 |       MINUS HASH                          |                            |       |       |            |          |
|  16 |        VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  17 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6728_DD6BD2C |     6 |   558 |     2   (0)| 00:00:01 |
|  18 |        VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  19 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6727_DD6BD2C |     6 |   540 |     2   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 4 (U - Unused (2))
---------------------------------------------------------------------------
 
   3 -  SEL$20B10B79
         U -  materialize / hint conflicts with another in sibling query block
           -  INLINE
 
   5 -  SEL$15B3653C
         U -  materialize / hint conflicts with another in sibling query block
           -  INLINE

38 rows selected. 

*/