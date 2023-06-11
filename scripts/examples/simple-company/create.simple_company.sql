create table sc#product_categories(
    product_category_id number generated always as identity primary key
    , product_category_name varchar2(50 char)
    , product_category_description varchar2(100 char)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);
    

create table sc#product_types(
    product_type_id number generated always as identity primary key
    , product_type_name varchar2(50 char)
    , product_type_description varchar2(100 char)
    , product_category_id number references sc#product_categories(product_category_id)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#products(
    product_id number generated always as identity primary key
    , product_code varchar2(50 char)
    , product_name varchar2(100 char)
    , product_description varchar2(4000 char)
    , product_type_id number references sc#product_types(product_type_id)
    , msrp_price number
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#product_prices(
    product_price_id number generated always as identity primary key
    , product_id number references sc#products(product_id)
    , price number not null check (price > 0)
    , effective_date date
    , expiry_date date
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
);

create table sc#regions(
    region_id number generated always as identity primary key
    , region_name varchar2(50 char)
    , region_description varchar2(100 char)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#customers(
    customer_id number generated always as identity primary key
    , customer_name varchar2(1000 char)
    , customer_notes varchar2(4000 char)
    , region_id number references sc#regions(region_id)
    , is_b2b number default 0 not null check (is_b2b in (0,1))
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#orders(
    order_id number generated always as identity primary key
    , purchase_order varchar2(50 char)
    , customer_id number references sc#customers(customer_id)
    , order_reference varchar2(100 char) generated always as ('O' || to_char(order_id,'fm09999') || 'C' || to_char(customer_id,'fm09999')) virtual
    , order_total number default 0 not null check (order_total >= 0)
    , open_date date
    , closed_date date
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#order_details(
    order_detail_id number generated always as identity primary key
    , order_id number references sc#orders(order_id)
    , product_id number references sc#products(product_id)
    , quantity number not null check (quantity > 0)
    , backorder_quantity number generated always as (quantity - shipped_quantity) check (backorder_quantity >= 0)
    , shipped_quantity number default 0 not null
    , unit_price number not null
    , extended_price number generated always as (quantity * unit_price) virtual
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
    , check (shipped_quantity >= 0 and shipped_quantity <= quantity)
);

create table sc#shipments(
    shipment_id number generated always as identity primary key
    , order_id number references sc#orders(order_id)
    , shipment_reference varchar2(100 char) generated always as ('O' || to_char(order_id,'fm09999') || 'S' || to_char(shipment_id,'fm09999')) virtual
    , requested_date date
    , requested_by varchar2(30 char)
    , prepared_date date
    , prepared_by varchar2(30 char) 
    , shipped_date date
    , shipped_by varchar2(30 char)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
);

create table sc#shipment_details(
    shipment_detail_id number generated always as identity primary key
    , shipment_id number references sc#orders(order_id)
    , order_detail_id number references sc#order_details(order_detail_id)
    , quantity number not null check (quantity > 0)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
);    

create table sc#invoices(
    invoice_id number generated always as identity primary key
    , customer_id number references sc#customers(customer_id)
    , order_id number references sc#orders(order_id)
    , shipment_id number references sc#shipments(shipment_id)
    , invoice_reference varchar2(100 char) generated always as ('O' || to_char(order_id,'fm09999') || 'S' || to_char(shipment_id,'fm09999') || 'I' || to_char(invoice_id,'fm09999')) virtual
    , invoice_total number not null check (invoice_total > 0)
    , payments_total number not null check (payments_total >= 0)
    , amount_due number generated always as (invoice_total - payments_total) virtual 
    , issue_date date
    , issue_by varchar2(30 char)
    , payment_due_date generated always as (issue_date + 90) virtual
    , closed_date date
    , closed_by varchar2(30 char)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
    , updated_date date
    , updated_by varchar2(30 char)
    , check (amount_due <= invoice_total)
);

create table sc#invoice_details(
    invoice_detail_id number generated always as identity primary key
    , invoice_id number references sc#invoices(invoice_id)
    , line_number number not null check (line_number > 0)
    , quantity number not null check(quantity > 0)
    , unit_amount number not null check (unit_amount > 0)
    , extended_amount number generated always as (quantity * unit_amount) virtual not null check (extended_amount > 0)
    , unit_discount number default 0 not null check (unit_discount > 0)
    , net_amount number generated always as ((quantity * (unit_amount - unit_discount))) virtual not null
    , description varchar2(4000)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
);

create table sc#invoice_payments(
    invoice_payment_id number generated always as identity primary key
    , invoice_id number references sc#invoices(invoice_id)
    , payment_amount number not null check (payment_amount > 0)
    , received_date date
    , received_by varchar2(30 char)
    , created_date date default sysdate
    , created_by varchar2(30 char) default user
);