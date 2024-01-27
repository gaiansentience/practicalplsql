prompt create data differences in products_source and products_target

begin

    update products_source 
    set name = replace(name,'Fuji','Fujiyama') 
    where 
        name like '%Fuji%' 
        and name not like '%Fujiyama%';
    
    update products_source 
    set description = replace(description,'Mount', 'Mt.') 
    where 
        description like '%Everest%' 
        and description not like '%Mt.%';
    
    update products_target 
    set unit_msrp = 25 
    where code = 'POSTER-FD';
    
    update products_target
    set style = replace(style, 'BW', 'Black and White ')
    where 
        code = 'POSTCARD-ES' 
        and style not like 'Black and White%';
    
    commit;

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/