set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin

    l_sql :=
q'[
select count(*) as difference_count 
from row_compare_full_join(products_source, products_target, columns(product_id))
]';
    
    execute immediate l_sql into i;
    dbms_output.put_line('function is called on hard parse, sql statement prints');
    execute immediate l_sql into i;
    dbms_output.put_line('no hard parse, function is not called, statement doesnt print');
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

function is called on hard parse, sql statement prints
no hard parse, function is not called, statement doesnt print


PL/SQL procedure successfully completed.


*/