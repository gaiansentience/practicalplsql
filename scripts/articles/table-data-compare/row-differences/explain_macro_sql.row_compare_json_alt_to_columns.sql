set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_json_alt_to_columns(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'BASIC')
/

/*
select base.row_source, j.*
from
    (
    select 
        coalesce(s.row_source, t.row_source) as row_source
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
    ) base,
    json_table(base.jdoc
        columns (
            PRODUCT_ID path '$.PRODUCT_ID.number()'
            , CODE path '$.CODE.string()'
            , NAME path '$.NAME.string()'
            , DESCRIPTION path '$.DESCRIPTION.string()'
            , STYLE path '$.STYLE.string()'
            , MSRP path '$.MSRP.number()'
        )
    ) j
order by "PRODUCT_ID", row_source



Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2104788181
 
----------------------------------------------------------------
| Id  | Operation                         | Name               |
----------------------------------------------------------------
|   0 | SELECT STATEMENT                  |                    |
|   1 |  SORT ORDER BY                    |                    |
|   2 |   NESTED LOOPS                    |                    |
|   3 |    VIEW                           |                    |
|   4 |     UNION-ALL                     |                    |
|   5 |      FILTER                       |                    |
|   6 |       MERGE JOIN OUTER            |                    |
|   7 |        TABLE ACCESS BY INDEX ROWID| PRODUCTS_SOURCE    |
|   8 |         INDEX FULL SCAN           | PRODUCTS_SOURCE_PK |
|   9 |        FILTER                     |                    |
|  10 |         SORT JOIN                 |                    |
|  11 |          TABLE ACCESS FULL        | PRODUCTS_TARGET    |
|  12 |      MERGE JOIN ANTI              |                    |
|  13 |       TABLE ACCESS BY INDEX ROWID | PRODUCTS_TARGET    |
|  14 |        INDEX FULL SCAN            | PRODUCTS_TARGET_PK |
|  15 |       FILTER                      |                    |
|  16 |        SORT JOIN                  |                    |
|  17 |         TABLE ACCESS FULL         | PRODUCTS_SOURCE    |
|  18 |    JSONTABLE EVALUATION           |                    |
----------------------------------------------------------------

*/

