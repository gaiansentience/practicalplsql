--test.assertion.limit_two_roles.sql

set feedback off;
set serveroutput on;

declare
    l_action varchar2(1000) := '***add staff with two roles';
    d univ_depts.dept_name%type := 'Philosophy';
    s univ_staff.staff_name%type := 'Picasso';
begin

    delete univ_dept_roles
    where 
        dept_name = d
        and staff_name = s;

    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, 'faculty', s)
        , (d, 'fellow', s);
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

--Success - ***add staff with two roles
--Philosophy staff members:
--    admin: Pike
--    chair: Descartes, Wittgenstein
--    faculty: Descartes, Moore, Pascal, Picasso, Russell, Wittgenstein
--    fellow: Picasso
--    secretary: Kirk

declare
    l_action varchar2(1000) := '***add staff member with three roles';
    d univ_depts.dept_name%type := 'Philosophy';
    s univ_staff.staff_name%type := 'Joyce';    
begin

    insert into univ_dept_roles (
        dept_name, role_name, staff_name)
    values 
        (d, 'secretary', s)
        , (d, 'assistant', s)
        , (d, 'intern', s);
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

--Error - ***add staff member with three roles
--ORA-08601: SQL assertion (PRACTICALPLSQL.LIMIT_TWO_ROLES) violated.

set feedback on;