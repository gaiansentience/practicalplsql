--create.procedure.display_staff.sql

create or replace procedure display_staff(
    p_dept in univ_depts.dept_name%type
)
is
    cursor c is
    select 
        role_name, 
        listagg(staff_name, ', ')
        within group (order by staff_name) as staff
    from univ_dept_roles
    where dept_name = p_dept
    group by role_name
    order by role_name;
    
begin
    dbms_output.put_line(p_dept || ' staff members:');
    for r in c loop
        dbms_output.put_line('    ' || r.role_name || ': ' || r.staff);
    end loop;
end;
/