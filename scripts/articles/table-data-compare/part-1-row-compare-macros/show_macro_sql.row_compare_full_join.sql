set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
        select count(*) as difference_count 
        from row_compare_full_join(products_source, products_target, columns(product_id))
    '
    into i;
    dbms_output.put_line(i || ' differences found');
end;
/

/*

select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID"
    , coalesce(s."CODE", t."CODE") as "CODE"
    , coalesce(s."NAME", t."NAME") as "NAME"
    , coalesce(s."DESCRIPTION", t."DESCRIPTION") as "DESCRIPTION"
    , coalesce(s."STYLE", t."STYLE") as "STYLE"
    , coalesce(s."UNIT_MSRP", t."UNIT_MSRP") as "UNIT_MSRP"
from   
    (
        select 
            'source' as row_source
            , s.*
        from p_source s   
    ) s
    full outer join (
        select 
            'target' as row_source
            , t.*
        from p_target t
    ) t
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and decode(s."CODE", t."CODE", 1, 0) = 1
        and decode(s."NAME", t."NAME", 1, 0) = 1
        and decode(s."DESCRIPTION", t."DESCRIPTION", 1, 0) = 1
        and decode(s."STYLE", t."STYLE", 1, 0) = 1
        and decode(s."UNIT_MSRP", t."UNIT_MSRP", 1, 0) = 1
where 
    s."PRODUCT_ID" is null 
    or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source

10 differences found

*/