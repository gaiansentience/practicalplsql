




--assertion, all departments must define all required roles (completeness of department type composition rules)
create assertion if not exists department_has_all_required_roles check (
    not exists (
        select 'a department' 
        from university_departments d
        where exists (
            select 'required role'
            from university_role_types r
            where r.is_required and not exists(
                select 'role is configured for department'
                from university_department_roles dr
                where dr.department_name = d.department_name 
                and dr.role_name = r.role_name))
        )
) novalidate deferrable initially deferred
/

--rewrite with universal syntax:
--all departments satisfy not exists a required role where not exists is configured
