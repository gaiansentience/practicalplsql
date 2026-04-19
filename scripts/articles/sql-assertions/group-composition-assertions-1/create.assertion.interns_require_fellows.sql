--create.assertion.interns_require_fellows.sql

drop assertion if exists interns_require_fellows;

create assertion if not exists interns_require_fellows check (
    not exists (
        select 'a department'
        from univ_depts d
        where 
            exists (
                select 'has interns'
                from univ_dept_roles i
                where 
                    i.dept_name = d.dept_name 
                    and i.role_name = 'intern'
                    and not exists (
                        select 'has research fellow'
                        from univ_dept_roles f
                        where 
                            f.dept_name = i.dept_name 
                            and f.role_name = 'fellow'
                    )
                )
        )
)
/
    
