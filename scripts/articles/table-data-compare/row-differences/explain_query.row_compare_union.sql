set pagesize 1000
column plan_table_output format a150

explain plan for
select u.* from
(
    (
        select 'source' as row_source, s.* from products_source s
        minus
        select 'source' as row_source, t.* from products_target t
    )
    union all
    (
        select 'target' as row_source, t.* from products_target t
        minus
        select 'target' as row_source, s.* from products_source s
    )
) u
order by u.product_id, u.row_source
/

select * from dbms_xplan.display(format => 'BASIC')
/

/*

Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 3321006140
 
-------------------------------------------------
| Id  | Operation             | Name            |
-------------------------------------------------
|   0 | SELECT STATEMENT      |                 |
|   1 |  SORT ORDER BY        |                 |
|   2 |   VIEW                |                 |
|   3 |    UNION-ALL          |                 |
|   4 |     MINUS HASH        |                 |
|   5 |      TABLE ACCESS FULL| PRODUCTS_SOURCE |
|   6 |      TABLE ACCESS FULL| PRODUCTS_TARGET |
|   7 |     MINUS HASH        |                 |
|   8 |      TABLE ACCESS FULL| PRODUCTS_TARGET |
|   9 |      TABLE ACCESS FULL| PRODUCTS_SOURCE |
-------------------------------------------------

16 rows selected. 

*/