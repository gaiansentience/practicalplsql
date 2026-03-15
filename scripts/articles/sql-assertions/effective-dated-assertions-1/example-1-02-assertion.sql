--example-1-02-assertion.sql

create assertion if not exists loyalty_discount_applied check (
    not exists (
        select 'order discount invalid for customer loyalty status'
        from 
            orders o, 
            customers c, 
            loyalty s
        where 
            o.customer_name = c.customer_name 
            and c.status = s.status
            and o.discount < s.discount_min
    )
)
/
