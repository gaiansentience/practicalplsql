select
    case when s.product_id is not null then 'source' else 'target' end as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.jrow, t.jrow) as jrow
from
    (select product_id, code, json_object(*) as jrow from products_source) s
    full outer join (select product_id, code, json_object(*) as jrow from products_target) t
        on s.product_id = t.product_id
        and s.code = t.code
        and json_equal(s.jrow, t.jrow)
where s.product_id is null or t.product_id is null
order by product_id, row_source
/

select * from row_compare(products_source, products_target, columns(product_id, code))
/

