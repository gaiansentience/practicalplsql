prompt create data differences in products_source and products_target

declare
l_update number := 1;
begin

    update products_source 
    set name = replace(name, 'Fuji', 'Fujiyama') 
    where 
        name like '%Fuji%' 
        and name not like '%Fujiyama%'
        and code <> 'PC-FJ';
    
    --on oci this update uses parallel query
    commit;    
    dbms_output.put_line('created differences in souce.name');
        
    update products_source 
    set description = replace(description, 'Mount', 'Mt.') 
    where description like '%Mount Everest%'; 

    dbms_output.put_line('created differences in source.description');
    
    update products_target 
    set msrp = 19 
    where code = 'P-FD';

    dbms_output.put_line('created differences in target.msrp');

    update products_target 
    set style = null 
    where code = 'PC-K2';
    
    
    dbms_output.put_line('created differences in target.style');
    
    
    update products_target
    set style = 'Monochrome'
    where code = 'PC-ES';
    
    dbms_output.put_line('created differences in target.style');

    
    delete from products_target
    where code = 'PC-S';
    
    dbms_output.put_line('removed row from target');

    commit;

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/