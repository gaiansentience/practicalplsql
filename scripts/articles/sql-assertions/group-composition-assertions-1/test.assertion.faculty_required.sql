--test.assertion.faculty_required.sql

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
    l_action varchar2(100) := '***create dept without faculty';
begin
    insert into univ_depts
    set dept_name = 'Philosophy';    
    commit;  
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line('SQLERRM WILL NOT SHOW DEFERRED ASSERTION ERRORS:');
        dbms_output.put_line('     ' || sqlerrm);
        dbms_output.put_line('USE FORMAT_ERROR_STACK TO SHOW DEFERRED ERRORS:');
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

declare
    l_action varchar2(100) := '***create dept with faculty';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';    
begin
    insert into univ_depts
    set dept_name = d;
    
    insert into univ_dept_roles(
        dept_name, role_name, staff_name)
    values 
        (d, r, 'Wittgenstein')
        , (d, r, 'Newton');
    
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

declare
    l_action varchar2(100) := '**add faculty members';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';    
begin    
    insert into univ_dept_roles(
        dept_name, role_name, staff_name)
    values 
        (d, r, 'Descartes')
        , (d, r, 'Jones');
    
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

declare
    l_action varchar2(100) := '**delete some faculty but not all';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';    
begin
    delete univ_dept_roles
    where 
        dept_name = d
        and role_name = r
        and staff_name = 'Descartes';
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/


prompt cannot delete all faculty from department
declare
    l_action varchar2(100) := 'Remove all faculty';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';    
begin
    delete univ_dept_roles
    where dept_name = d
        and role_name = r;
        
    commit;
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

--can only delete all faculty when also deleting department in same transaction
declare
    l_action varchar2(100) := 'Remove Philosophy dept and all faculty';
    d univ_depts.dept_name%type := 'Philosophy';
    r univ_roles.role_name%type := 'faculty';    
begin
    delete univ_dept_roles
    where 
        dept_name = d
        and role_name = r;
        
    delete univ_depts
    where dept_name = d;
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
end;
/

set feedback on;