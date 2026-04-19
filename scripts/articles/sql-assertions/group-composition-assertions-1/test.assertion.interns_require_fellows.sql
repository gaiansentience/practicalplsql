--test.assertion.interns_require_fellows.sql

set serveroutput on;

prompt clear all fellows and interns for tests
declare
    l_action varchar2(1000) := 'remove all fellows and interns';
    d univ_depts.dept_name%type := 'Philosophy';
    f univ_roles.role_name%type := 'fellow';    
    i univ_roles.role_name%type := 'intern';    
begin
    delete univ_dept_roles
    where 
        dept_name = d
        and role_name in (f, i);
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

prompt add interns without any fellows
declare
    l_action varchar2(1000) := 'add interns without any fellows';
    d univ_depts.dept_name%type := 'Philosophy';
    f univ_roles.role_name%type := 'fellow';    
    i univ_roles.role_name%type := 'intern';    
begin

    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, i, 'Joyce')
        , (d, i, 'Jones');
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

prompt add interns and fellows
declare
    l_action varchar2(1000) := 'add interns and fellows';
    d univ_depts.dept_name%type := 'Philosophy';
    f univ_roles.role_name%type := 'fellow';    
    i univ_roles.role_name%type := 'intern';    
begin

    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, f, 'Joyce')
        , (d, f, 'Picasso')
        , (d, i, 'Newton')
        , (d, i, 'James')
        , (d, i, 'Jones');
        
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

prompt cannot delete fellows when there are interns
declare
    l_action varchar2(1000) := 'remove all fellows';
    d univ_depts.dept_name%type := 'Philosophy';
    f univ_roles.role_name%type := 'fellow';    
begin
    delete univ_dept_roles
    where 
        dept_name = d
        and role_name = f;
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/
