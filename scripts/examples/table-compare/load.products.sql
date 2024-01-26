prompt loading products table

declare
    i number;
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
        insert into products (
            code
            , name
            , description
            , style
            , unit_msrp
            , unit_cost
            , unit_qty
        ) values (
            p_code
            , p_name
            , p_description
            , p_style
            , p_unit_msrp
            , p_unit_cost
            , p_unit_qty);
    end insert_product;
begin

    execute immediate 'truncate table products';
    
    insert_product('POSTER-ES','Mount Everest Summit Poster','Poster of Mount Everest summit after a storm.','18 in x 20 in',30,5,1);
    insert_product('POSTER-EB','Mount Everest Basecamp Poster','Poster of Mount Everest basecamp at dawn','18 in x 20 in',30,5,1);
    insert_product('POSTER-FD','Mount Fuji Dawn Poster','Poster of Mount Fuji at dawn','11 in x 17 in',20,4,1);
    insert_product('POSTER-FS','Mount Fuji Sunset Poster','Poster of Mount Fuji at sunset.','11 in x 17 in',20,4,1);
    insert_product('POSTER-K2','K2 Summit Poster','Poster of K2 summit.','11 in x 17 in',20,4,1);
    insert_product('POSTCARD-ES','Mount Everest Postcard Set','Set of postcards featuring Mount Everest.','5 in x 7 in',9,2,6);
 
    commit;
    
    select count(*) into i
    from products;
    
    dbms_output.put_line(i || ' records loaded to products table');
    
exception
    when others then
        dbms_output.put_line('Error loading products table: ' || sqlerrm);
end;
/

