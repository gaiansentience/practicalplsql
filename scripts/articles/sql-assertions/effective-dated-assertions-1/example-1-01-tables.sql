create table if not exists loyalty(
    status varchar2(10) 
        constraint loyalty_pk 
        primary key,
    discount_minimum number(5,4) default 0 not null
)
/

prompt insert the discount minimum for each loyalty status
begin
    insert into loyalty(status, discount_minimum)
    values
        ('New', 0),
        ('Preferred', .05),
        ('Elite', 0.10);
    
    commit;
end;
/


create table if not exists customers(
    customer_name varchar2(10) 
        constraint customers_pk 
        primary key,
    status varchar2(10) default 'New' 
        constraint customers_fk_loyalty
        references loyalty(status) not null    
)
/

create table if not exists orders(
    order_id integer generated always as identity primary key,
    customer_name varchar2(10)
        constraint orders_fk_customers
        references customers(customer_name) not null,
    discount number(5,4) default 0 not null,
    placed date default sysdate not null
)
/
