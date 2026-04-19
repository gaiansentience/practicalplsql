alter session disable parallel dml;

select user, banner_full from v$version;



--relative composition
--univ_depts with admins must have assistants
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
    
--?? must be deferrable??.. no, assistants can be inserted first