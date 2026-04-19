--test.assertion.limit_two_chairs.sql
set feedback off;
set serveroutput on;

declare
    l_action varchar2(1000) := '***add two co-chairs';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'chair';    
begin

    delete univ_dept_roles
    where dept_name = d and role_name = r;
    
    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, r, 'Wittgenstein')
        , (d, r, 'Descartes');
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

declare
    l_action varchar2(1000) := '***add a third co-chair';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'chair';    
begin

    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, r, 'Russell');
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

set feedback on;