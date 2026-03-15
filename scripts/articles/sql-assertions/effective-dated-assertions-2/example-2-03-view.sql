create or replace view review_order_discounts as
select 
    c.customer_name, c.status, (100 * s.discount_min) || '%' as loyalty_discount
    , o.order_id, (100 * o.discount) || '%' as order_discount
    , case 
        when o.placed < c.status_updated then 'Legacy Order'
        when o.discount < s.discount_min then 'Insufficient' 
        when o.discount = s.discount_min then 'Meets Minimum' 
        else 'Exceeds Minimum' 
    end as discount_valid
    , o.placed
    , c.status_updated
from 
    customers c 
    join loyalty s on c.status = s.status
    join orders o on c.customer_name = o.customer_name
order by c.customer_name, o.order_id
/
