--test.assertion.limit_one_admin.sql

declare
    l_action varchar2(1000) := '***add multiple dept admins';
    d univ_depts.dept_name%type := 'Philosophy';
    a univ_roles.role_name%type := 'admin';    
begin
    display_staff(d);
    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values (d, a, 'Joyce')
        , (d, a, 'Picasso');
        
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
