--create.assertion.interns_require_fellows.alt.sql

drop assertion if exists interns_require_fellows;

create assertion if not exists interns_require_fellows check (
    not exists (
        select 'an intern'
        from univ_dept_roles i
        where 
            i.role_name = 'intern'
            and not exists (
                select 'research fellow in same department'
                from univ_dept_roles f
                where 
                    f.dept_name = i.dept_name 
                    and f.role_name = 'fellow'
            )
    )
)
/
    
