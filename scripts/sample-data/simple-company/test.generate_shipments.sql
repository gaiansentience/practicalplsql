declare
l_shipment_id number;
begin

for r_o in (
    select o.order_id, min(o.open_date) as min_open_date, sum(od.backorder_quantity) as on_backorder
    from sc#orders o join sc#order_details od on o.order_id = od.order_id
    where o.closed_date is null 
    group by o.order_id
    having sum(od.backorder_quantity) > 0
    order by min(o.open_date) fetch first 200 rows only) loop

insert into sc#shipments(order_id, requested_by) 
values (r_o.order_id, 'order-processing') 
returning shipment_id into l_shipment_id;

insert into sc#shipment_details(shipment_id, order_detail_id, quantity)
select l_shipment_id, od.order_detail_id
, case when od.backorder_quantity <= 3 then od.backorder_quantity else trunc(dbms_random.value(2,od.backorder_quantity)) end as quantity
from sc#orders o join sc#order_details od on o.order_id = od.order_id
where od.order_id = r_o.order_id and od.backorder_quantity > 0;

merge into sc#order_details dest using
(select o.order_id, od.order_detail_id, s.shipment_id, od.shipped_quantity + sd.quantity as shipped_quantity
from sc#orders o join sc#order_details od on o.order_id = od.order_id join sc#shipments s on o.order_id = s.order_id 
join sc#shipment_details sd on s.shipment_id = sd.shipment_id and od.order_detail_id = sd.order_detail_id
where s.shipment_id = l_shipment_id) src
on (dest.order_detail_id = src.order_detail_id)
when matched then
    update set dest.shipped_quantity = src.shipped_quantity, dest.updated_date = sysdate, dest.updated_by = 'shipping'; 
    

merge into sc#orders dest using
(select o.order_id, sum(od.quantity) as order_quantity, sum(od.shipped_quantity) as reported_shipped_quantity, sum(sd.quantity) as actual_shipped_quantity
from sc#orders o join sc#order_details od on o.order_id = od.order_id join sc#shipments s on o.order_id = s.order_id join sc#shipment_details sd on s.shipment_id = sd.shipment_id and od.order_detail_id = sd.order_detail_id
where o.order_id = r_o.order_id
group by o.order_id
having sum(od.quantity) = sum(od.shipped_quantity) and sum(od.backorder_quantity) = 0 and sum(od.quantity) = sum(sd.quantity)) src
on (src.order_id = dest.order_id)
when matched then
    update set dest.closed_date = sysdate, updated_date = sysdate, updated_by = 'shipping'
    where src.order_quantity = src.reported_shipped_quantity and src.order_quantity = src.actual_shipped_quantity;


commit;

end loop;

end;
/