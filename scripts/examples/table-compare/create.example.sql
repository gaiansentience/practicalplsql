@@drop.example.sql;

create table products (
    product_id number generated always as identity 
        constraint products_pk primary key,
    code varchar2(100) not null 
        constraint products_uk unique,
    name varchar2(100) not null,
    description varchar2(1000),
    style varchar2(100),
    unit_msrp number,
    unit_cost number,
    unit_qty number default 1 not null
);
    
declare
    procedure insert_product(
        p_code in products.code%type,
        p_name in products.name%type,
        p_description in products.description%type,
        p_style in products.style%type,
        p_unit_msrp in products.unit_msrp%type,
        p_unit_cost in products.unit_cost%type,
        p_unit_qty in products.unit_qty%type default 1)
    is
    begin
        insert into products (code, name, description, style, unit_msrp, unit_cost, unit_qty)
        values (p_code, p_name, p_description, p_style, p_unit_msrp, p_unit_cost, p_unit_qty);
    end insert_product;
begin

    insert_product('POSTER-ES','Mount Everest Summit Poster','Poster of Mount Everest summit after a storm.','18 in x 20 in',30,5,1);
    insert_product('POSTER-EB','Mount Everest Basecamp Poster','Poster of Mount Everest basecamp at dawn','18 in x 20 in',30,5,1);
    insert_product('POSTER-FD','Mount Fuji Dawn Poster','Poster of Mount Fuji at dawn','11 in x 17 in',20,4,1);
    insert_product('POSTER-FS','Mount Fuji Sunset Poster','Poster of Mount Fuji at sunset.','11 in x 17 in',20,4,1);
    insert_product('POSTER-K2','K2 Summit Poster','Poster of K2 summit.','11 in x 17 in',20,4,1);
    insert_product('POSTCARD-ES','Mount Everest Postcard Set','Set of postcards featuring Mount Everest.','5 in x 7 in',9,2,6);
 
    commit;
    
end;
/

create table products_source as select * from products;

alter table products_source add (
    constraint products_source_pk primary key (product_id),
    constraint products_source_uk unique(code)
    );

create table products_target as select * from products;

alter table products_target add (
    constraint products_target_pk primary key (product_id),
    constraint products_target_uk unique(code)
    );
