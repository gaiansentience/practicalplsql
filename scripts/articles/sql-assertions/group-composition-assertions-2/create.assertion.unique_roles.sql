
--assertion, all unique roles can only have one position
--not exists a unique role with another unique role in same department
create assertion if not exists department_unique_roles_are_not_duplicated check (
    not exists (
        select 'a department with a unique role'
        from university_department_roles dr, university_role_types r
        where dr.role_name = r.role_name
        and r.is_unique
        and exists (
            select 'a second assignment of role'
            from university_department_roles ddrr
            where ddrr.department_name = dr.department_name
            and ddrr.role_name = dr.role_name
            and ddrr.full_name > dr.full_name
            )
        )
) --novalidate deferrable initially deferred
/

