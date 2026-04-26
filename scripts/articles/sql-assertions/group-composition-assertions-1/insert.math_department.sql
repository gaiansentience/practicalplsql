--insert.math_department.sql

set serveroutput on;
set feedback off;

declare
    l_action varchar2(100) := '***clear math department roles and department before tests';
    d univ_depts.dept_name%type := 'Math';
begin
    delete univ_dept_roles
    where dept_name = d;
    
    delete univ_depts
    where dept_name = d;
    commit;
    dbms_output.put_line('Success - ' || l_action);
end;
/


declare
    l_action varchar2(100) := '***create math department with 3 chairs, 2 admins, an intern and no faculty';
    d univ_depts.dept_name%type := 'Math';
    c univ_roles.role_name%type := 'chair';
    a univ_roles.role_name%type := 'admin';
begin
    insert into univ_depts
    set dept_name = d;
    
    insert into univ_dept_roles(dept_name, role_name, staff_name)
    values 
        (d, c, 'Pascal')
        , (d, c, 'Russell')
        , (d, c, 'Newton')
        , (d, 'intern', 'Newton')        
        , (d, a, 'Moore')
        , (d, a, 'James');
    
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

declare
    l_action varchar2(100) := '***create math department with valid composition';
    d univ_depts.dept_name%type := 'Math';
    f univ_roles.role_name%type := 'faculty';
    c univ_roles.role_name%type := 'chair';
begin
    insert into univ_depts
    set dept_name = d;
    
    insert into univ_dept_roles(dept_name, role_name, staff_name)
    values 
        (d, c, 'Pascal')
        , (d, c, 'Russell')
        , (d, f, 'Pascal')
        , (d, f, 'Newton')        
        , (d, 'fellow', 'Moore')
        , (d, 'intern', 'James')
        , (d, 'admin', 'Picasso');
    
    commit;
    dbms_output.put_line('Success - ' || l_action);    
    display_staff(d);
end;
/


set feedback on;


