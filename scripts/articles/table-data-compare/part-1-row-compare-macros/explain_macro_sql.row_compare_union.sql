set pagesize 1000
column plan_table_output format a150

explain plan for
with source_rows as (
    select /*+ materialize */ *
    from products_source
), target_rows as (
    select /*+ materialize */ *
    from products_target
    order by product_id
)
select * from row_compare_union(source_rows, target_rows, columns(product_id));

select * from dbms_xplan.display(format => 'BASIC')
/

/*
Notes:
The materialize hint is just a hint, and the use of CTE expressions does not always result in materialization.
Because we used dbms_output to print the sql statement, the query will be included in the script output here.

select u.* 
from (
        (
            select 'source' as row_source, s.* 
            from products_source s
            minus
            select 'source' as row_source, t.* 
            from products_target t
        )
        union all
        (
            select 'target' as row_source, t.* 
            from products_target t
            minus
            select 'target' as row_source, s.* 
            from products_source s
        )
    ) u
 order by u."PRODUCT_ID", u.row_source


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2084978541
 
--------------------------------------------------
| Id  | Operation              | Name            |
--------------------------------------------------
|   0 | SELECT STATEMENT       |                 |
|   1 |  VIEW                  |                 |
|   2 |   SORT ORDER BY        |                 |
|   3 |    VIEW                |                 |
|   4 |     UNION-ALL          |                 |
|   5 |      MINUS HASH        |                 |
|   6 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |
|   7 |       TABLE ACCESS FULL| PRODUCTS_TARGET |
|   8 |      MINUS HASH        |                 |
|   9 |       TABLE ACCESS FULL| PRODUCTS_TARGET |
|  10 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |
--------------------------------------------------

17 rows selected. 

*/