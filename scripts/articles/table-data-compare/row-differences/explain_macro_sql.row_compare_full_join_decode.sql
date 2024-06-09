set pagesize 1000
column plan_table_output format a150

explain plan for
select * from row_compare_full_join_decode(products_source, products_target, columns(product_id))
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
        and decode(s."CODE", t."CODE", 1, 0) = 1
        and decode(s."NAME", t."NAME", 1, 0) = 1
        and decode(s."DESCRIPTION", t."DESCRIPTION", 1, 0) = 1
        and decode(s."STYLE", t."STYLE", 1, 0) = 1
        and decode(s."MSRP", t."MSRP", 1, 0) = 1
where 
    s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source



Explained.


PLAN_TABLE_OUTPUT                                                                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1669472241
 
--------------------------------------------------
| Id  | Operation              | Name            |
--------------------------------------------------
|   0 | SELECT STATEMENT       |                 |
|   1 |  SORT ORDER BY         |                 |
|   2 |   VIEW                 |                 |
|   3 |    UNION-ALL           |                 |
|   4 |     FILTER             |                 |
|   5 |      HASH JOIN OUTER   |                 |
|   6 |       TABLE ACCESS FULL| PRODUCTS_SOURCE |
|   7 |       TABLE ACCESS FULL| PRODUCTS_TARGET |
|   8 |     HASH JOIN ANTI     |                 |
|   9 |      TABLE ACCESS FULL | PRODUCTS_TARGET |
|  10 |      TABLE ACCESS FULL | PRODUCTS_SOURCE |
--------------------------------------------------

*/