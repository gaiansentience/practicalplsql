--create.assertion.limit_two_roles.universal.sql

drop assertion if exists limit_two_roles;

create assertion if not exists limit_two_roles check (
    all (
        --staff members with two roles in department
        select r1.dept_name, r1.staff_name, r1.role_name as role_1, r2.role_name as role_2
        from
            univ_dept_roles r1,
            univ_dept_roles r2
        where
            r1.dept_name = r2.dept_name
            and r1.staff_name = r2.staff_name
            and r2.role_name > r1.role_name
        ) a
    satisfy (
        not exists (
            select 'staff member has three roles'
            from univ_dept_roles r3
            where 
                a.dept_name = r3.dept_name
                and a.staff_name = r3.staff_name
                and r3.role_name > a.role_2
        )
    )
)
/
    
