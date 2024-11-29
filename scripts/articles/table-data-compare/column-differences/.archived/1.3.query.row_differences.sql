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
        and json_equal(json_object(s.*), json_object(t.*))
where s.product_id is null or t.product_id is null
order by product_id, row_source
/
--ORA-40579: wildcard star expansion '*' not allowed