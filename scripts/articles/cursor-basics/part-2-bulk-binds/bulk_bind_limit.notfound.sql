--this script relies on the presence of the simple-employees example
set serveroutput on;

Prompt Bulk Bind With Limit Clause and %notfound
declare
    cursor c_items is
        select level as n
        from dual
        connect by level <= 5;
    type t_items is table of c_items%rowtype;
    r_item c_items%rowtype;
    l_items t_items;
    i number := 0;
begin
    dbms_output.put_line('Fetching single records');
    open c_items;
    loop
        i := i + 1;
        fetch c_items into r_item;
        dbms_output.put('fetch ' || i 
            || ': r_item.n = ' || r_item.n);
        print_boolean_attribute(c_items%notfound, '%notfound');            
        exit when c_items%notfound;
    end loop;
    close c_items;

    dbms_output.put_line('Bulk Collect with Limit');
    i := 0;
    open c_items;    
    loop
        i := i + 1;
        fetch c_items bulk collect into l_items limit 3;
        dbms_output.put('bulk fetch ' || i 
            || ': l_items.count = ' || l_items.count);
        dbms_output.put(case when l_items.count = 0 then ' no' end || ' values ');
        
$if dbms_db_version.version < 21 $then    
        for i in 1..l_items.count loop
$else
        for i in indices of l_items loop
$end
            dbms_output.put(l_items(i).n || ' ');
        end loop;
            
        print_boolean_attribute(c_items%notfound, '%notfound');            
        exit when l_items.count = 0;
        
    end loop;
    close c_items;
end;
/

/* Script Output:
Bulk Bind With Limit Clause and %notfound
Fetching single records
fetch 1: r_item.n = 1(%notfound is false)
fetch 2: r_item.n = 2(%notfound is false)
fetch 3: r_item.n = 3(%notfound is false)
fetch 4: r_item.n = 4(%notfound is false)
fetch 5: r_item.n = 5(%notfound is false)
fetch 6: r_item.n = 5(%notfound is true)
Bulk Collect with Limit
bulk fetch 1: l_items.count = 3 values 1 2 3 (%notfound is false)
bulk fetch 2: l_items.count = 2 values 4 5 (%notfound is true)
bulk fetch 3: l_items.count = 0 no values (%notfound is true)
*/