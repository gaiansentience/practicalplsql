set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
        select count(*) as difference_count 
        from row_compare_json_alt(products_source, products_target, columns(product_id, code))
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
    , coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , "PRODUCT_ID"
            , "CODE"
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join 
    (
        select 
            'target' as row_source
            , "PRODUCT_ID"
            , "CODE"
            , json_object(*) as jdoc 
        from p_target    
    ) t 
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and s."CODE" = t."CODE"
        and json_equal(s.jdoc, t.jdoc)
where 
    s."PRODUCT_ID" is null 
    or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source

*/