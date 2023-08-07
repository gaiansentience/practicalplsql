set feedback off;
set serveroutput on;

prompt Using Cursor Object Iteration Control To Populate A Collection
declare
    cursor c_data is
        select 
            name,
            job
        from employees;

    type t_table is table of c_data%rowtype index by employees.name%type;
    l_rows t_table;
begin

    l_rows := t_table(for r in c_data index r.name => r);
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    
end;
/
