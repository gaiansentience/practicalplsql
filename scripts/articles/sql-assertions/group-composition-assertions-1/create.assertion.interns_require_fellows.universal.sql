--create.assertion.interns_require_fellows.universal.sql

drop assertion if exists interns_require_fellows;

create assertion if not exists interns_require_fellows check (
    all (
        --departments with interns
        select d.dept_name
        from univ_depts d
        where 
            exists (
                select 'has interns'
                from univ_dept_roles i
                where
                    i.dept_name = d.dept_name
                    and i.role_name = 'intern'
            )
        ) a
    satisfy (
        exists (
            select 'research fellow in department'
            from univ_dept_roles f
            where 
                f.dept_name = a.dept_name 
                and f.role_name = 'fellow'
        )
    )
)
/
    
