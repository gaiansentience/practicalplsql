select
    case when s.product_id is not null then 'source' else 'target' end as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.name, t.name) as name
    , coalesce(s.description, t.description) as description
    , coalesce(s.style, t.style) as style
    , coalesce(s.msrp, t.msrp) as msrp
from
    products_source s
    full outer join products_target t
        on s.product_id = t.product_id
        and s.code = t.code
        and decode(s.name, t.name, 1, 0) = 1
        and decode(s.description, t.description, 1, 0) = 1
        and decode(s.style, t.style, 1, 0) = 1
        and decode(s.msrp, t.msrp, 1, 0) = 1
where s.product_id is null or t.product_id is null
order by product_id, row_source
/