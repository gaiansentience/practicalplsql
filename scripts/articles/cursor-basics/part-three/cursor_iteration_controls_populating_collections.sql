set feedback off;
set serveroutput on;

prompt Using Cursor Iteration Controls To Populate Collections
declare
    c_data sys_refcursor; 
	type t_rec is record(id number, info varchar2(4000));
    type t_table is table of t_rec index by pls_integer;
    l_rows t_table;
begin

	open c_data for 
        select 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= 250;   

    l_rows := t_table(for r t_rec in c_data sequence => r);
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    
    close c_data;
    
end;
/
