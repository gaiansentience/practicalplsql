set pagesize 1000
column plan_table_output format a150

explain plan for
with source_table as (
    select --+ materialize
        s.* 
    from products_source s
), target_table as (
    select --+ materialize
        t.* 
    from products_target t
)
select u.* 
from
    (
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

select * from dbms_xplan.display(format => 'ALL -ALIAS -PROJECTION')
/

/*


Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 54213257
 
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                | Name                       | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                         |                            |    12 | 26304 |    15   (7)| 00:00:01 |
|   1 |  TEMP TABLE TRANSFORMATION               |                            |       |       |            |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6725_DD6BD2C |       |       |            |          |
|   3 |    TABLE ACCESS FULL                     | PRODUCTS_SOURCE            |     6 |   540 |     3   (0)| 00:00:01 |
|   4 |   LOAD AS SELECT (CURSOR DURATION MEMORY)| SYS_TEMP_0FD9D6726_DD6BD2C |       |       |            |          |
|   5 |    TABLE ACCESS FULL                     | PRODUCTS_TARGET            |     6 |   558 |     3   (0)| 00:00:01 |
|   6 |   SORT ORDER BY                          |                            |    12 | 26304 |     9  (12)| 00:00:01 |
|   7 |    VIEW                                  |                            |    12 | 26304 |     8   (0)| 00:00:01 |
|   8 |     UNION-ALL                            |                            |       |       |            |          |
|   9 |      MINUS HASH                          |                            |       |       |            |          |
|  10 |       VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  11 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6725_DD6BD2C |     6 |   540 |     2   (0)| 00:00:01 |
|  12 |       VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  13 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6726_DD6BD2C |     6 |   558 |     2   (0)| 00:00:01 |
|  14 |      MINUS HASH                          |                            |       |       |            |          |
|  15 |       VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  16 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6726_DD6BD2C |     6 |   558 |     2   (0)| 00:00:01 |
|  17 |       VIEW                               |                            |     6 | 13104 |     2   (0)| 00:00:01 |
|  18 |        TABLE ACCESS FULL                 | SYS_TEMP_0FD9D6725_DD6BD2C |     6 |   540 |     2   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------------------------
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2
---------------------------------------------------------------------------
 
   2 -  SEL$1
           -  materialize
 
   4 -  SEL$2
           -  materialize

35 rows selected. 

*/