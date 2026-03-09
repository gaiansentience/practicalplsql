--assertion only applies to orders created after status was last updated
create assertion if not exists loyalty_discount_applied check (
    not exists (
        select 'current order discount invalid for current customer loyalty status'
        from 
            orders o, 
            customers c, 
            loyalty s
        where 
            o.customer_name = c.customer_name and c.status = s.status
            and o.order_discount < s.discount_minimum
            and o.placed >= c.status_updated
    )
)
/