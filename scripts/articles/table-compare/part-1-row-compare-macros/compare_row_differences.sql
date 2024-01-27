--compare row differences with json and full outer join
select 
    coalesce(s.id, t.id) as id,
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , product_id as id
            , json_object(*) as jdoc 
        from products_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , product_id as id
            , json_object(*) as jdoc 
        from products_target    
    ) t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where s.id is null or t.id is null
/
