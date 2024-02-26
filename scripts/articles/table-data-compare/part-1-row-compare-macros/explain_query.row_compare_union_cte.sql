set pagesize 1000
column plan_table_output format a150

explain plan for
with source_table as (
    select /*+ materialize */ s.* from products_source s
), target_table as (
    select /*+ materialize */ t.* from products_target t
)
select u.* from (
    (
        select 'source' as row_source, s.* from source_table s
        minus
        select 'source' as row_source, t.* from target_table t
    )
    union all
    (
        select 'target' as row_source, t.* from target_table t
        minus
        select 'target' as row_source, s.* from source_table s
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
Plan hash value: 54213257
 
-------------------------------------------------------------------------------
| Id  | Operation                                | Name                       |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                            |
|   1 |  TEMP TABLE TRANSFORMATION               |                            |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D66AD_E134873 |
|   3 |    TABLE ACCESS FULL                     | PRODUCTS_SOURCE            |
|   4 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D66AE_E134873 |
|   5 |    TABLE ACCESS FULL                     | PRODUCTS_TARGET            |
|   6 |   SORT ORDER BY                          |                            |
|   7 |    VIEW                                  |                            |
|   8 |     UNION-ALL                            |                            |
|   9 |      MINUS HASH                          |                            |
|  10 |       VIEW                               |                            |
|  11 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D66AD_E134873 |
|  12 |       VIEW                               |                            |
|  13 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D66AE_E134873 |
|  14 |      MINUS HASH                          |                            |
|  15 |       VIEW                               |                            |
|  16 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D66AE_E134873 |
|  17 |       VIEW                               |                            |
|  18 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D66AD_E134873 |
-------------------------------------------------------------------------------

25 rows selected. 

*/