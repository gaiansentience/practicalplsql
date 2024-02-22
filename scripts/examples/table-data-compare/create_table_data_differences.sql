prompt create data differences in products_source and products_target

begin

    update products_source 
    set name = replace(name, 'Fuji', 'Fujiyama') 
    where 
        name like '%Fuji%' 
        and name not like '%Fujiyama%'
        and code <> 'PC-FJ';
    
    update products_source 
    set description = replace(description, 'Mount', 'Mt.') 
    where description like '%Mount Everest%'; 
    
    update products_target 
    set msrp = 19 
    where code = 'P-FD';

    update products_target 
    set style = null 
    where code = 'PC-K2';
    
    update products_target
    set style = 'Monochrome'
    where code = 'PC-ES';
    
    delete from products_target
    where code = 'PC-S';
    
    commit;

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/