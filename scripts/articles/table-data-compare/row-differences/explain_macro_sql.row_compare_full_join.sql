set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_full_join(products_source, products_target, columns(product_id))
/

select * from dbms_xplan.display(format => 'BASIC')
/

/*
select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID"
    , coalesce(s."CODE", t."CODE") as "CODE"
    , coalesce(s."NAME", t."NAME") as "NAME"
    , coalesce(s."DESCRIPTION", t."DESCRIPTION") as "DESCRIPTION"
    , coalesce(s."STYLE", t."STYLE") as "STYLE"
    , coalesce(s."MSRP", t."MSRP") as "MSRP"
from   
    (
        select 'source' as row_source, src.* from p_source src   
    ) s
    full outer join (
        select 'target' as row_source, tgt.* from p_target tgt
    ) t
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and s."CODE" = t."CODE"
        and s."NAME" = t."NAME"
        and s."DESCRIPTION" = t."DESCRIPTION"
        and s."STYLE" = t."STYLE"
        and s."MSRP" = t."MSRP"
where 
    s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source



Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 13840447
 
--------------------------------------------------
| Id  | Operation              | Name            |
--------------------------------------------------
|   0 | SELECT STATEMENT       |                 |
|   1 |  SORT ORDER BY         |                 |
|   2 |   VIEW                 | VW_FOJ_0        |
|   3 |    HASH JOIN FULL OUTER|                 |
|   4 |     VIEW               |                 |
|   5 |      TABLE ACCESS FULL | PRODUCTS_TARGET |
|   6 |     VIEW               |                 |
|   7 |      TABLE ACCESS FULL | PRODUCTS_SOURCE |
--------------------------------------------------

*/