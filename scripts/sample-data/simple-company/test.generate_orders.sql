declare
l_order_id number;
l_order_total number;
begin

for r_c in (
select customer_id, case is_b2b when 0 then round(dbms_random.value(1,5)) else round(dbms_random.value(5,40)) end as items, is_b2b
from sc#customers
order by dbms_random.value()
fetch first 5000 rows only) loop

insert into sc#orders (customer_id,order_total,open_date)
values (r_c.customer_id,0,sysdate + round(dbms_random.value(0,60)))
returning order_id into l_order_id;

insert into sc#order_details(order_id, product_id, quantity, unit_price,shipped_quantity)
select l_order_id, product_id, case r_c.is_b2b when 0 then round(dbms_random.value(1,3)) else round(dbms_random.value(5,20)) end as quantity, msrp_price,0
from sc#products
order by dbms_random.value()
fetch first r_c.items rows only;

--select sum(extended_price) into l_order_total
--from sc#order_details where order_id = l_order_id;
--
--update sc#orders set order_total = l_order_total where order_id = l_order_id;

merge into sc#orders dest using (
select order_id, sum(extended_price) as order_total
from sc#order_details where order_id = l_order_id
group by order_id
) src on (dest.order_id = src.order_id)
when matched then
    update set dest.order_total = src.order_total;
    
end loop;


commit;


end;