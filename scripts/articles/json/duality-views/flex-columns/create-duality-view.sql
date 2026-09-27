create or replace json relational duality view products_dv as
select
    json {
        '_id' : { 'productId' : p.id }
        , 'sku' : p.sku
        , 'name'  : p.name
        , 'description'   : p.description
        , 'unitPrice' : p.unit_price
        , p.detail as flex column
--        , 'moreInfo' : p.detail
        }
from products p with insert update delete
/

create or replace json relational duality view customers_dv as 
select
    json {
        '_id' : { 'customerId' : c.id }
        , 'name' : c.name
        --, c.detail as flex column
        , 'moreInfo' : c.detail
        , 'orders' :
            [
            select json {
                'orderId' : o.id
                , 'placed' : o.placed
                , 'paid' : o.paid
                , 'totalPrice' : generated using (select sum(od.extended_price) from order_details od where od.order_id = o.id)
                }
            from orders o with insert update delete
            where o.customer_id = c.id
            
            ]
    
    }
from customers c with insert update delete
/


create or replace json relational duality view orders_dv as
select
    json {
        '_id' : { 'orderId' : o.id }
        , 'customerInfo' : 
            (select json { 
                'customerId' : c.id
                , 'name' : c.name
                , c.detail as flex column }
            from customers c with insert update
            where c.id = o.customer_id)
        , 'placed' : o.placed
        , 'paid' : o.paid
        , 'orderDetails' : 
            [
            select json {
                'id' : od.id
                , 'quantity' : od.quantity
                , 'unitPrice' :od.unit_price
                , 'extendedPrice' : od.extended_price with noupdate
                --'productInfo' : 
                , unnest (
                    select json {
                        'sku' : p.sku
                        , 'name' : p.name
                        , 'description' : p.description
                        --, p.detail as flex column
                        --ORA-42633: Table 'PRODUCTS' cannot be flexible and unnested in JSON-relational duality view.
                        , 'moreInfo' : p.detail
                        }
                    from products p with noinsert noupdate nodelete
                    where p.id = od.id)              
                }
            from order_details od with insert update delete
            where od.order_id = o.id 
            ]
        , 'totalItems' : generated using path '$.details.quantity.sum()'
        , 'totalPrice' : generated using path '$.details.extendedPrice.sum()'
        }
from orders o with insert update delete
/



