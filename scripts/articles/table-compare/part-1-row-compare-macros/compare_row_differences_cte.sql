--compare row differences using json and cte
with source_json as (
    select 
        'source' as row_source
        , product_id as id
        , json_object(*) as jdoc 
    from products_source
), target_json as (
    select 
        'target' as row_source
        , product_id as id
        , json_object(*) as jdoc 
    from products_target
)
select 
    coalesce(s.id, t.id) as id,
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    source_json s
    full outer join target_json t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where s.id is null or t.id is null
/
