--create.assertion.faculty_required.immediate.sql

drop assertion if exists faculty_required;

create assertion if not exists faculty_required check (
    not exists (
        select 'a department' 
        from univ_depts d
        where 
            not exists (
                select 'has faculty'
                from univ_dept_roles f
                where 
                    f.dept_name = d.dept_name 
                    and f.role_name = 'faculty'
            )
    )
) not deferrable
/

