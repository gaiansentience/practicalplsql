create or replace JSON RELATIONAL DUALITY VIEW orders_jdv AS 
select 
    json{
        '_id' : o.order_id
        , 'discount' : o.discount
        , 'customerInfo' :
            (select json{ 'customerName' : c.customer_name}
            from customers c with insert
            where c.customer_name = o.customer_name)
    }
from 
    orders o with insert
/


select * from orders_jdv
where json_value(data,'$.customerInfo.customerName.string()') = 'Liza';

insert into orders_jdv(data)
values (
'{"discount":0.36,"customerInfo":{"customerName":"Liza"}}'
)
/

--todo:  duality view for managing loyalty discounts, managing customer loyalty


create or replace json relational duality view customer_loyalty_jdv as
select 
    json{ 
    '_id' : {
        'customerName' : cl.customer_name
        , 'effective' : cl.effective
        }
    , 'status' : cl.status
    , 'expires' : cl.expires with nocheck
--    , 'active#row' : nvl2(cl.active#row, true, false) with nocheck
    }
from customer_loyalty cl with insert update
--where cl.active#row = cl.customer_name with check option
/

declare
l_date date := sysdate;
begin

update customer_loyalty_jdv c
set data = json_transform(data, set '$.expires' = path '$inputDate' passing l_date as "inputDate")--'{"status":"New","expires":"2026-03-27T09:52:00",,"_id":{"customerName":"Andrew","effective":"2026-03-26T10:19:00"}}'
where c.data."_id".customerName = 'Andrew' and c.data."_id".expires.date() is null;
--.timestamp() = timestamp '2026-03-26 10:19:00'

end;
/
 


insert into customer_loyalty_jdv (data)
values ('
{"status":"Preferred","expires":null
,"_id":{"customerName":"Andrew","effective":"2026-03-27T09:52:00"}}')
/

select * from customer_loyalty_jdv c
where 
--json_value(data,'$._id.customerName.string()') = 'Andrew';
c.data.expires.date() is null;



create or replace json relational duality view customer_jdv as
select json{
    '_id' : { 'customerName' : c.customer_name}
    , 'loyaltyProgram' value 
    (
        select json_arrayagg( json {
            'status' : cl.status
            , 'effective' : cl.effective
            , 'expires' : cl.expires
            })
            from customer_loyalty cl with insert noupdate nodelete
            where cl.customer_name = c.customer_name and cl.active#row = cl.customer_name with check option
    )
    }
from customers c with insert
/

select json_serialize(data pretty) as fmt_data, data
from customer_jdv c
where c.data."_id".customerName = 'Nina';

update customer_jdv
set data = '{"_id":{"customerName":"Nina"},"loyaltyProgram":[{"status":"Preferred"}]}'
where json_value(data,'$._id.customerName.string()')= 'Nina'
/

update customer_jdv c
set data = '
{"_id":{"customerName":"Nina"}
,"loyaltyProgram":[
{"status":"Elite","effective":"2026-03-26T10:17:31","expires":"2026-03-27T09:52:00"}
,{"status":"New","effective":"2026-03-27T09:52:00","expires":null}
]
,"_metadata":{"etag":"E62A62281153DABE68D0BC8204CCE752","asof":"000000000040257D"}}
'
where c.data."_id".customerName = 'Nina' ;

update customer_jdv c
set data = '{"_id":{"customerName":"Nina"},"loyaltyProgram":[{"status":"Preferred"}]}'
where c.data."_id".customerName = 'Nina'
/


insert into customer_jdv
set data = '{"_id":{"customerName":"Alex"},"loyaltyProgram":[{"status":"New"}]}';

commit;

select * from customer_loyalty;

update customer_jdv
set data = '{"_id":{"customerName":"Andrew"},"loyaltyProgram":[{"status":"Preferred"}]}'
where json_value(data,'$._id.customerName.string()')= 'Andrew'
/
