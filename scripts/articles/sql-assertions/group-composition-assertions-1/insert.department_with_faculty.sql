--insert.department_with_faculty.sql

set serveroutput on;
set feedback off;

declare
    l_action varchar2(100) := '***clear univ_dept_roles and univ_depts before tests';
begin
    delete univ_dept_roles;
    delete univ_depts;
    commit;
    dbms_output.put_line('Success - ' || l_action);
end;
/


declare
    l_action varchar2(100) := '***create department with faculty to test more assertions';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';
begin
    insert into univ_depts
    set dept_name = d;
    
    insert into univ_dept_roles(dept_name, role_name, staff_name)
    values 
        (d, r, 'Wittgenstein')
        , (d, r, 'Descartes')
        , (d, r, 'Moore')
        , (d, r, 'Russell')
        , (d, r, 'Pascal');
    
    commit;
    dbms_output.put_line('Success - ' || l_action);
    
    display_staff(d);
end;
/

set feedback on;