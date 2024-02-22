prompt reload data for products_source and products_target from products
@@load.products.sql;

begin

    execute immediate 'truncate table products_source';
    
    execute immediate 'truncate table products_target';
    
    insert all
        into products_source
        into products_target
    select * from products;
        
    commit;

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

@@create_table_data_differences.sql;