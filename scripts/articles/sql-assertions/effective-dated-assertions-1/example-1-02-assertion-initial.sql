--example-1-02-assertion-initial.sql

prompt creating assertion fails when customers.status is nullable
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

--ORA-08689: CREATE ASSERTION failed
--ORA-08673: Equijoin "C"."STATUS"="S"."STATUS" found does not meet the criteria to do a FAST validation.

prompt make customers.status not null
alter table customers modify status not null;

prompt assertion can now be created
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