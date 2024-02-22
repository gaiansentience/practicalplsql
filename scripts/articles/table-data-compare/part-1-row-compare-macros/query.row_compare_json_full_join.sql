--compare row differences with json and full outer join
--query is null aware and clob aware
select 
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.product_id, t.product_id) as product_id,
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , product_id
            , json_object(*) as jdoc 
        from products_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , product_id
            , json_object(*) as jdoc 
        from products_target    
    ) t
        on s.product_id = t.product_id
        and json_equal(s.jdoc, t.jdoc)
where s.product_id is null or t.product_id is null
order by product_id, row_source
/
