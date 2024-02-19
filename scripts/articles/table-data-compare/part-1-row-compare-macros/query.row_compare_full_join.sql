--compare row differences with full outer join
--can support clobs with dbms_lob.compare as join clause
--equality join is not null aware
--identical rows with a null column will show as differences
select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.name, t.name) as name
    , coalesce(s.description, t.description) as description
    , coalesce(s.style, t.style) as style
    , coalesce(s.unit_msrp, t.unit_msrp) as unit_msrp
from   
    (
        select 
            'source' as row_source
            , s.*
        from products_source s   
    ) s
    full outer join (
        select 
            'target' as row_source
            , t.*
        from products_target t
    ) t
        on s.product_id = t.product_id
        and s.code = t.code
        and s.name = t.name
        and s.description = t.description
        and s.style = t.style
        and s.unit_msrp = t.unit_msrp
where 
    s.product_id is null 
    or t.product_id is null
order by product_id, row_source
/
