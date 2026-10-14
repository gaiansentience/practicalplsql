--data structure to illustrate bulk processing and set based processing

--customers have channels
--items are available for all or specific channels
--some items can be configured
--configurations can be customized
--orders can be large and complex based on configurations
--orders can be copied from other orders (template orders or specific orders)

--some complex use cases
        --copy order-items and order-item-details
        --limit copy by compatibility
        --some items are incompatible
        --some item details are incompatible even if items are compatible
        
        --add a third level of item detail configurations
        
        
        --using values of with forall and sql%bulk_rowcount
        
        --bulk collect valid items to copy
        
        --use forall to insert items
        
        --get indices of items with details
        
        --use values of to insert compatible item details
        
        --use sql%bulk_rowcount to see items that had no compatible details
        --get indices of items with incompatible details
        
        --delete items inserted with incompatible details





create sequence channel_id_seq;

create table channels(
    channel_id number primary key default channel_id_seq.nextval,
    channel_name varchar2(100) not null unique
)
/

create sequence configuration_id_seq;

create table configurations(
    configuration_id number primary key default configuration_id_seq.nextval,
    configuration json
)
/

create sequence item_type_id_seq;

create table item_types (
    item_type_id number primary key default item_type_id_seq.nextval,
    item_type varchar2(50) not null unique
)
/

create sequence item_id_seq;

create table items(
    item_id number primary key default item_id_seq.nextval,
    item_name varchar2(100) not null unique,
    item_type_id number not null references item_types(item_type_id),
    configuration_id references configurations(configuration_id),
    configuration_custom json
)
/

create table item_components(
    item_id number references items(item_id),
    component_item_id number references items(item_id),
    configuration_id number references configurations(configuration_id),
    qty number,
    configuration_custom json,
    constraint primary key (item_id, component_item_id)
)
/

create table item_channels(
    item_id number not null references items(item_id),
    channel_id number not null references channels(channel_id),
    constraint primary key (item_id, channel_id)
)
/

create sequence customer_id_seq;

create table customer(
    customer_id number primary key default customer_id_seq.nextval,
    customer_name varchar2(100) not null unique,
    channel_id number not null  references channels(channel_id)
)
/

create sequence order_status_type_id_seq;

create table order_status_types(
    order_status_type_id number primary key default order_status_type_id_seq.nextval,
    order_status_type varchar2(20) not null unique
)
/

create sequence order_id_seq;

create table orders(
    order_id number primary key default order_id_seq.nextval,
    customer_id number references customers(customer_id),
    source_order_id number references orders(order_id),
    order_reference varchar2(50),
    placed date not null,
    placed_by varchar2(50) not null,
    order_status_type_id number not null references order_status_types (order_status_type_id)
)
/

create sequence order_detail_id_seq;

create table order_details(
    order_detail_id number primary key default order_detail_id_seq.nextval, 
    order_id number not null references orders(order_id),
    item_id number not null references items(item_id),
    qty number not null,
    price number not null,
    extended_price generated as (qty * price) virtual,
    configuration_id number references configurations(configuration_id),
    custom_configuration json
)
/

