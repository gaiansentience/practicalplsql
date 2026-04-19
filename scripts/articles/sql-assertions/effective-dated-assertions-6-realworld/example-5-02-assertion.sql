--assertion only looks for order discounts that are not correct for effective status period 
create assertion if not exists loyalty_discount_applied check (
    not exists (
        select 'order discount invalid for effective customer loyalty status'
        from 
            orders o, 
            customer_loyalty c, 
            loyalty_discounts s
        where 
            o.customer_id = c.customer_id
            and c.status_id = s.status_id
            and not o.discount between s.discount_min and s.discount_max
            and o.placed >= c.effective and (c.expires is null or o.placed < c.expires)
            and o.placed >= s.effective and (s.expires is null or o.placed < s.expires)
    )
)
/


--adding effective date to loyalty table as part of pk made status alone invalid for fk
--fk also cannot be constrained via band join
--need to create assertion to represent the foreign key between customer_loyalty and loyalty_discounts table
create assertion if not exists customer_loyalty_fk_loyalty_discounts check (
    not exists (
        select 'a customer loyalty period'
        from customer_loyalty a
        where not exists (
            select 'an effective loyalty status exists'
            from loyalty_discounts s
            where 
                s.status_id = a.status_id
                and a.effective >= s.effective and (s.expires is null or a.effective < s.expires)
        )
    )
)
/