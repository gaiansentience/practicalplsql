set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_union(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'ALL -ALIAS -PROJECTION')
/


--notes:  
--because the macro uses inline views, it cannot materialize the two tables
--this results in two full scans of each table
    
/*


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2084978541
 
------------------------------------------------------------------------------------------
| Id  | Operation              | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |                 |    12 | 26304 |    13   (8)| 00:00:01 |
|   1 |  VIEW                  |                 |    12 | 26304 |    13   (8)| 00:00:01 |
|   2 |   SORT ORDER BY        |                 |    12 | 26304 |    13   (8)| 00:00:01 |
|   3 |    VIEW                |                 |    12 | 26304 |    12   (0)| 00:00:01 |
|   4 |     UNION-ALL          |                 |       |       |            |          |
|   5 |      MINUS HASH        |                 |       |       |            |          |
|   6 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |     6 |   540 |     3   (0)| 00:00:01 |
|   7 |       TABLE ACCESS FULL| PRODUCTS_TARGET |     6 |   558 |     3   (0)| 00:00:01 |
|   8 |      MINUS HASH        |                 |       |       |            |          |
|   9 |       TABLE ACCESS FULL| PRODUCTS_TARGET |     6 |   558 |     3   (0)| 00:00:01 |
|  10 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |     6 |   540 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

17 rows selected. 

*/