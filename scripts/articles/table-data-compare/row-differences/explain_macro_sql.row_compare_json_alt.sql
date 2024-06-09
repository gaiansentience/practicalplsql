set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_json_alt(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'BASIC')
/

/*
select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID"
    , coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , "PRODUCT_ID"
            , json_object(* returning json) as jdoc 
        from p_source    
    ) s
    full outer join 
    (
        select 
            'target' as row_source
            , "PRODUCT_ID"
            , json_object(* returning json) as jdoc 
        from p_target    
    ) t 
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and json_equal(s.jdoc, t.jdoc)
where s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source



Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 320625626
 
---------------------------------------------------------------
| Id  | Operation                        | Name               |
---------------------------------------------------------------
|   0 | SELECT STATEMENT                 |                    |
|   1 |  SORT ORDER BY                   |                    |
|   2 |   VIEW                           |                    |
|   3 |    UNION-ALL                     |                    |
|   4 |     FILTER                       |                    |
|   5 |      MERGE JOIN OUTER            |                    |
|   6 |       TABLE ACCESS BY INDEX ROWID| PRODUCTS_SOURCE    |
|   7 |        INDEX FULL SCAN           | PRODUCTS_SOURCE_PK |
|   8 |       FILTER                     |                    |
|   9 |        SORT JOIN                 |                    |
|  10 |         TABLE ACCESS FULL        | PRODUCTS_TARGET    |
|  11 |     MERGE JOIN ANTI              |                    |
|  12 |      TABLE ACCESS BY INDEX ROWID | PRODUCTS_TARGET    |
|  13 |       INDEX FULL SCAN            | PRODUCTS_TARGET_PK |
|  14 |      FILTER                      |                    |
|  15 |       SORT JOIN                  |                    |
|  16 |        TABLE ACCESS FULL         | PRODUCTS_SOURCE    |
---------------------------------------------------------------

*/
