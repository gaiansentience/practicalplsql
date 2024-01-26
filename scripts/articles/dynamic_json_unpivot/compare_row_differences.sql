with source_json as (
    select 
        'src' as src_tbl
        , product_id as id
        , json_object(*) as jdoc 
    from products_source
), target_json as (
    select 
        'tgt' as src_tbl
        , product_id as id
        , json_object(*) as jdoc 
    from products_target
)
select 
    coalesce(s.id, t.id) as id,
    coalesce(s.src_tbl, t.src_tbl) as src_tbl, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    source_json s
    full outer join target_json t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where  
    s.id is null or t.id is null
/


select 
    coalesce(s.id, t.id) as id,
    coalesce(s.src_tbl, t.src_tbl) as src_tbl, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'src' as src_tbl
            , product_id as id
            , json_object(*) as jdoc 
        from products_source    
    ) s
    full outer join (
        select 
            'tgt' as src_tbl
            , product_id as id
            , json_object(*) as jdoc 
        from products_target    
    ) t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where  
    s.id is null or t.id is null
/


--using macro
select *--id, src_tbl, jdoc
from get_row_compare(products_source,products_target, columns(product_id, code))
/


