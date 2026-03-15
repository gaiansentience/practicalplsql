--assertion only looks for order discounts that are not correct for effective status period 
create assertion if not exists loyalty_discount_applied check (
    not exists (
        select 'order discount invalid for effective customer loyalty status'
        from 
            orders o, 
            customer_loyalty c, 
            loyalty s
        where 
            o.customer_name = c.customer_name and c.status = s.status
            and o.discount < s.discount_minimum
            and o.placed >= c.effective and (c.expires is null or o.placed < c.expires)
    )
)
/
