--create.assertion.limit_one_admin.alt.sql

drop assertion if exists limit_one_admin;

create assertion if not exists limit_one_admin check (
    not exists (
        select 'an admin'
        from univ_dept_roles a1
        where 
            a1.role_name = 'admin'
            and exists (
                select 'another admin'
                from univ_dept_roles a2
                where 
                    a1.dept_name = a2.dept_name 
                    and a1.role_name = a2.role_name 
                    and a1.staff_name > a2.staff_name
            )
    )
)
/
