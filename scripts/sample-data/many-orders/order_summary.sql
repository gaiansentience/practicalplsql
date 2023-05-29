--declare
--
--cursor c is
with order_detail_base as
(
select 
a.account_id, a.account_name, 
c.customer_id, c.customer_name, 
o.order_id, o.order_date, 
--pt.product_type_id, pt.product_type_name, 
d.product_id, p.product_name, 
d.quantity, p.unit_price, d.quantity * p.unit_price as extended_price
from 
accounts a
join customers c on c.account_id = a.account_id
join orders o on c.customer_id = o.customer_id
join order_details d on o.order_id = d.order_id
join products p on d.product_id = p.product_id
--join product_types pt on p.product_type_id = pt.product_type_id
--order by customer_id, order_id, product_type_id, product_id
)
select account_id, min(order_date), max(order_date), count(distinct customer_id) as customer_count, count(distinct order_id) as order_count, sum(extended_price) as total_sales, sum(extended_price) / count(distinct order_id) as average_order
from order_detail_base
group by account_id;


select * from order_details order by order_id, product_id;