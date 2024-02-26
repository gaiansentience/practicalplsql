prompt loading products table

declare
    i number;
    procedure insert_product(
        p_code in products.code%type,
        p_name in products.name%type,
        p_description in products.description%type,
        p_style in products.style%type,
        p_msrp in products.msrp%type
        )
    is
    begin
        insert into products (
            code
            , name
            , description
            , style
            , msrp
        ) values (
            p_code
            , p_name
            , p_description
            , p_style
            , p_msrp
        );
    end insert_product;
begin

    execute immediate 'truncate table products';
    
    insert_product('P-ES','Everest Summit','Mount Everest Summit','18x20',30);
    insert_product('P-EB','Everest Basecamp','Mount Everest Basecamp','18x20',30);
    insert_product('P-FD','Fuji Dawn','Mount Fuji at dawn','11x17',20);
    insert_product('P-FS','Fuji Sunset','Mount Fuji at sunset','11x17',20);
    insert_product('P-K2','K2 Summit','K2 summit','11x17',20);
    insert_product('PC-ES','Everest Postcards','Mount Everest postcards','5x7',9);
    insert_product('PC-FJ','Fuji Postcards','Mount Fuji postcards',null,9);
    insert_product('PC-K2','K2 Postcards','K2 postcards','Color',9);
    insert_product('PC-S','Shasta Postcards','Mount Shasta postcards','5x7',9);
 
    commit;
    
    select count(*) into i
    from products;
    
    dbms_output.put_line(i || ' records loaded to products table');
    
exception
    when others then
        dbms_output.put_line('Error loading products table: ' || sqlerrm);
end;
/

