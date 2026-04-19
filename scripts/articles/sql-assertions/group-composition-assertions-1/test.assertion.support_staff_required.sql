--test.assertion.support_staff_required.sql
set serveroutput on;
set feedback off;

declare
    l_action varchar2(1000) := '***remove all support staff';
    d univ_depts.dept_name%type := 'Philosophy';        
begin
    delete univ_dept_roles
    where
        dept_name = d
        and role_name in ('admin', 'secretary');
    
    commit;
exception
    when others then
        rollback;
        dbms_output.put_line('Errors - ' || l_action);
        dbms_output.put_line(dbms_utility.format_error_stack());
end;
/

declare
    l_action varchar2(1000) := '***remove all support staff, insert admin';
    d univ_depts.dept_name%type := 'Philosophy';
begin
    delete univ_dept_roles
    where
        dept_name = d
        and role_name in ('admin', 'secretary');
        
    insert into univ_dept_roles
    set 
        dept_name = d
        , role_name = 'admin'
        , staff_name = 'Jones';
        
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/


declare
    l_action varchar2(1000) := '***add secretary';
    d univ_depts.dept_name%type := 'Philosophy';    
begin
    insert into univ_dept_roles
    set 
        dept_name = d
        , role_name = 'secretary'
        , staff_name = 'Joyce';
    
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

declare
    l_action varchar2(1000) := '***delete secretary';
    d univ_depts.dept_name%type := 'Philosophy';    
begin
    delete univ_dept_roles
    where 
        dept_name = d
        and role_name = 'secretary'
        and staff_name = 'Joyce';
    
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/
        
prompt finalize support staff
declare
    l_action varchar2(1000) := '***finalize support staff';
    d univ_depts.dept_name%type := 'Philosophy';
begin

    delete univ_dept_roles 
    where dept_name = d and role_name in ('admin', 'secretary');
    
    insert into univ_dept_roles
    values
        (d, 'admin', 'Pike')
        , (d, 'secretary', 'Kirk');
                
    commit;
    dbms_output.put_line('Success - ' || l_action);
    display_staff(d);
end;
/

set feedback on;