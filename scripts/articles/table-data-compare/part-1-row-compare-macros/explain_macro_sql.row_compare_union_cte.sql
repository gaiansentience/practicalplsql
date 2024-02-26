set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_union_cte(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'BASIC')
/

/*

Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2482291778
 
--------------------------------------------------------------------------------
| Id  | Operation                                 | Name                       |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                          |                            |
|   1 |  VIEW                                     |                            |
|   2 |   TEMP TABLE TRANSFORMATION               |                            |
|   3 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6660_1748EAA |
|   4 |     TABLE ACCESS FULL                     | PRODUCTS_SOURCE            |
|   5 |    LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6661_1748EAA |
|   6 |     TABLE ACCESS FULL                     | PRODUCTS_TARGET            |
|   7 |    SORT ORDER BY                          |                            |
|   8 |     VIEW                                  |                            |
|   9 |      UNION-ALL                            |                            |
|  10 |       MINUS HASH                          |                            |
|  11 |        VIEW                               |                            |
|  12 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6660_1748EAA |
|  13 |        VIEW                               |                            |
|  14 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6661_1748EAA |
|  15 |       MINUS HASH                          |                            |
|  16 |        VIEW                               |                            |
|  17 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6661_1748EAA |
|  18 |        VIEW                               |                            |
|  19 |         TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6660_1748EAA |
--------------------------------------------------------------------------------

*/