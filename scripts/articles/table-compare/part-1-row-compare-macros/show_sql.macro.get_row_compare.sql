set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
    select count(*) as difference_count 
    from get_row_compare(products_source, products_target, columns(product_id))
    '
    into i;
    dbms_output.put_line(i || ' differences found');
end;
/

/*
select 
    coalesce(s.id, t.id) as id,
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , "PRODUCT_ID" as id
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , "PRODUCT_ID" as id
            , json_object(*) as jdoc 
        from p_target    
    ) t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where s.id is null or t.id is null    

10 differences found

*/