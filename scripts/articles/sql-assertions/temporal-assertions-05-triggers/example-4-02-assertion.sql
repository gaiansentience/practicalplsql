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


--need to create assertion to represent the foreign key between customer_loyalty and loyalty_discounts table
--fk also cannot be constrained via band join
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

--assertions to ensure no overlapping periods in effective dated tables
--cf chris saxon: https://blogs.oracle.com/sql/how-to-stop-overlapping-date-ranges-in-oracle-ai-database

--with these assertions in place, trigger gets mutating tables error when converting updates to inserts
create assertion if not exists loyalty_discounts_check_overlap_periods check (
    all (select status, effective, expires from loyalty_discounts) p1
    satisfy (
        not exists (
            select 'overlapping period'
            from loyalty_discounts p2
            where p1.status = p2.status
            and p1.effective < p2.effective
            and (p1.expires is null or p2.effective < p1.expires)
            )
    )
) deferrable initially deferred
/


create assertion if not exists customer_loyalty_check_overlap_periods check (
    all (select customer_name, effective, expires from customer_loyalty) p1
    satisfy (
        not exists (
            select 'overlapping period'
            from customer_loyalty p2
            where p1.customer_name = p2.customer_name
            and p1.effective < p2.effective
            and (p1.expires is null or p2.effective < p1.expires)
            )
    )
) deferrable initially deferred
/

--TODO: add assertions to make effective periods contiguous???

--TODO: add assertion to require an active record with expires null ?  unrealistic
---not exists a status where not exists a period with null expires
---assertion requiring only one active row (handled by unique index)


--TODO: add assertion to require effective dates to be > all previous effective dates
--not exists a status with null expires where exists a period expired is not null and effective date >