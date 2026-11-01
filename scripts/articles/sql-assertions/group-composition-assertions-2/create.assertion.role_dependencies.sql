


--cross role dependency assertions
--not exists a department with a role where not exists the dependent role in same department
create assertion if not exists department_has_all_required_role_dependencies check (
    not exists (
        select 'a department'
        from university_departments d
        where exists (
            select 'a role with required role'
            from university_department_roles dr, university_cross_role_dependencies c
            where dr.department_name = d.department_name
            and dr.role_name = c.role_name
            and not exists (
                select 'required role exists'
                from university_department_roles ddrr
                where ddrr.department_name = dr.department_name
                and ddrr.role_name = c.required_role_name
                )
            )    
        )
) novalidate deferrable initially deferred
/

