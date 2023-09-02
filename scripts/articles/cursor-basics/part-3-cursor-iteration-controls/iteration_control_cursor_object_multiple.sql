--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Multiple Cursor Objects
declare
    cursor c_rep is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_REP';

    cursor c_mgr is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
begin
    print_boolean_attribute(c_rep%isopen,'c_rep%isopen');
    print_boolean_attribute(c_mgr%isopen,'c_mgr%isopen');
    
    for r_iterand in c_rep, c_mgr loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
    print_boolean_attribute(c_rep%isopen,'c_rep%isopen');
    print_boolean_attribute(c_mgr%isopen,'c_mgr%isopen');
end;
/

/* Script Output:
Cursor Iteration Control: Multiple Cursor Objects
(c_rep%isopen is false)
(c_mgr%isopen is false)
John SALES_REP
Jane SALES_REP
Julie SALES_REP
Alex SALES_REP
Sarah SALES_REP
Ann SALES_MGR
Tobias SALES_MGR
(c_rep%isopen is false)
(c_mgr%isopen is false)
*/