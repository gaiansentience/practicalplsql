create or replace view review_order_discounts as
select 
    c.customer_name, p.status, (100 * s.discount_min) || '%' as loyalty_discount
    , o.order_id, (100 * o.discount) || '%' as order_discount
    , case 
        when o.discount < s.discount_min then 'Insufficient' 
        when o.discount = s.discount_min then 'Meets Minimum' 
        else 'Exceeds Minimum' 
    end as discount_valid
    , o.placed
    , p.effective
    , p.expires
    , s.effective as status_effective
    , s.expires as status_expires
from 
    customers c 
    join customer_loyalty p on c.customer_name = p.customer_name
    join loyalty s on p.status = s.status 
    join orders o on c.customer_name = o.customer_name 
where
    o.placed >= p.effective and (p.expires is null or o.placed < p.expires)
    and o.placed >= s.effective and (s.expires is null or o.placed < s.expires)
order by c.customer_name, o.order_id
/
