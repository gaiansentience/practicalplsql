--assertion only looks for order discounts that are not correct for effective status period 
create assertion if not exists loyalty_discount_applied check (
    not exists (
        select 'order discount invalid for effective customer loyalty status effective'
        from 
            orders o, 
            customer_loyalty c, 
            loyalty_discounts s
        where 
            o.customer_name = c.customer_name 
            and c.status = s.status
            and o.discount < s.discount_min
            and o.placed >= c.effective and (c.expires is null or o.placed < c.expires)
            and o.placed >= s.effective and (s.expires is null or o.placed < s.expires)
    )
)
/


--adding effective date to loyalty table as part of pk made status alone invalid for fk
--fk also cannot be constrained via band join
--need to create assertion to represent the foreign key between customer_loyalty and loyalty table
create assertion if not exists customer_loyalty_fk_loyalty_discounts check (
    not exists (
        select 'a customer loyalty period'
        from customer_loyalty a
        where not exists (
            select 'an effective loyalty status exists'
            from loyalty_discounts s
            where 
                s.status = a.status
                and a.effective >= s.effective and (s.expires is null or a.effective < s.expires)
        )
    )
)
/