--create.assertion.faculty_required.universal.sql

drop assertion if exists faculty_required;

create assertion if not exists faculty_required check (
    all (
        select dept_name 
        from univ_depts
        ) a
    satisfy (
        exists (
            select 'has faculty'
            from univ_dept_roles f
            where 
                f.dept_name = a.dept_name 
                and f.role_name = 'faculty'
        )
    )
) deferrable initially deferred
/

