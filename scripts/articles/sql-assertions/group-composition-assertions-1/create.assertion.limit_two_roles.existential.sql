--create.assertion.limit_two_roles.existential.sql

drop assertion if exists limit_two_roles;

create assertion if not exists limit_two_roles check (
not exists (
    select r1.staff_name, r1.role_name, r2.role_name, r3.role_name
    from 
        univ_dept_roles r1,
        univ_dept_roles r2,
        univ_dept_roles r3
    where 
        r1.dept_name = r2.dept_name 
        and r2.dept_name = r3.dept_name
        and r1.staff_name = r2.staff_name 
        and r2.staff_name = r3.staff_name
        and r2.role_name > r1.role_name
        and r3.role_name > r2.role_name
    )
)
/
    
