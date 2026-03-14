create or replace view review_order_discounts as
select 
    c.customer_name, c.status, (100 * s.discount_minimum) || '%' as loyalty_discount
    , o.order_id, (100 * o.order_discount) || '%' as order_discount
    , case 
        when o.placed < c.status_updated then 'Legacy Order'
        when o.order_discount < s.discount_minimum then 'Insufficient' 
        when o.order_discount = s.discount_minimum then 'Meets Minimum' 
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
