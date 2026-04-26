--create.assertion.admins_require_assistants.sql

create assertion if not exists admins_require_assistants check (
not exists (
    select 'a department'
    from univ_depts d
    where 
    exists (
        select 'has admin'
        from univ_dept_roles adm
        where adm.dept_name = d.dept_name and adm.role_name = 'admin'
        and not exists (
            select 'has assistant'
            from univ_dept_roles ast
            where ast.dept_name = adm.dept_name and ast.role_name = 'assistant'
            )
        )
    )
)
/
drop assertion if exists admins_require_assistants;