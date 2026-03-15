create or replace view review_order_discounts as
select 
    c.customer_name as customer
    , o.order_id
    , o.placed as order_placed
    , (100 * o.discount) || '%' as discount    
    , l.status
    , (100 * s.discount_min) || '%' as status_min
    , (100 * s.discount_max) || '%' as status_max
    , case 
        when o.discount < s.discount_min then 'Insufficient' 
        when o.discount = s.discount_min then 'Minimum' 
        when o.discount < s.discount_max then 'Valid'
        when o.discount = s.discount_max then 'Maximum'
        else 'Excessive' 
    end as order_status
    , p.effective status_effective
    , p.expires as status_expires
    , s.effective as discount_effective
    , s.expires as discount_expires
from 
    customers c 
    join orders o on c.customer_id = o.customer_id     
    join customer_loyalty p on c.customer_id = p.customer_id
    join loyalty_discounts s on p.status_id = s.status_id 
    join loyalty_status l on s.status_id = l.status_id
where
    o.placed >= p.effective and (p.expires is null or o.placed < p.expires)
    and o.placed >= s.effective and (s.expires is null or o.placed < s.expires)
order by c.customer_name, o.order_id
/

