set serveroutput on;

Prompt Bulk Collect Limit: Exit Before Processing When Count = 0
declare
    cursor c_items(p_count in number) is
        select level as n
        from dual
        connect by level <= p_count;
    type t_items is table of c_items%rowtype;
    l_items t_items;
    i number := 0;
begin
    
    dbms_output.put_line('Total items is not a multiple of limit');
    i := 0;
    open c_items(5);    
    loop
        i := i + 1;
        fetch c_items bulk collect into l_items limit 3;
        dbms_output.put('bulk fetch ' || i 
            || ': l_items.count = ' || l_items.count 
            || case when l_items.count > 0 then ' values ' end);
        if l_items.count = 0 then 
            dbms_output.put_line(' exit on empty');
        end if;
        exit when l_items.count = 0;
$if dbms_db_version.version < 21 $then    
        for i in 1..l_items.count loop
$else
        for i in indices of l_items loop
$end
            dbms_output.put(l_items(i).n || ' ');
        end loop;
        dbms_output.put_line('processed');                    
    end loop;
    close c_items;
    
    dbms_output.put_line('Total items is a multiple of limit');
    i := 0;
    open c_items(6);    
    loop
        i := i + 1;
        fetch c_items bulk collect into l_items limit 3;
        dbms_output.put('bulk fetch ' || i 
            || ': l_items.count = ' || l_items.count 
            || case when l_items.count > 0 then ' values ' end);
        if l_items.count = 0 then 
            dbms_output.put_line(' exit on empty');
        end if;
        exit when l_items.count = 0;
$if dbms_db_version.version < 21 $then    
        for i in 1..l_items.count loop
$else
        for i in indices of l_items loop
$end
            dbms_output.put(l_items(i).n || ' ');
        end loop;
        dbms_output.put_line('processed');                    
    end loop;
    close c_items;

end;
/

/* Script Output:
Bulk Collect Limit: Exit Before Processing When Count = 0
Total items is not a multiple of limit
bulk fetch 1: l_items.count = 3 values 1 2 3 processed
bulk fetch 2: l_items.count = 2 values 4 5 processed
bulk fetch 3: l_items.count = 0 exit on empty
Total items is a multiple of limit
bulk fetch 1: l_items.count = 3 values 1 2 3 processed
bulk fetch 2: l_items.count = 3 values 4 5 6 processed
bulk fetch 3: l_items.count = 0 exit on empty
*/