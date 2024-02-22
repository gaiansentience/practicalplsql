--compare row differences with json and full outer join
select 
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.product_id, t.product_id) as product_id,
    coalesce(s.code, t.code) as code,
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , product_id
            , code
            , json_object(*) as jdoc 
        from products_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , product_id
            , code
            , json_object(*) as jdoc 
        from products_target    
    ) t
        on s.product_id = t.product_id
        and s.code = t.code
        and json_equal(s.jdoc, t.jdoc)
where 
    s.product_id is null or t.product_id is null
order by product_id, row_source
/
