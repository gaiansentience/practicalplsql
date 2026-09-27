
--assertion, all max paired roles must have no more than two positions
--not exists a max paired role with a second max paired role in same department where exists a third role in same department
create assertion if not exists department_max_paired_roles_not_exceeded check (
    not exists (
        select 'a department with paired roles'
        from university_department_roles dr, university_role_types r, university_department_roles dr2
        where dr.role_name = r.role_name
        and r.max_paired
        and dr.department_name = dr2.department_name
        and dr.role_name = dr2.role_name
        and dr.full_name < dr2.full_name
        and exists (
            select 'a third assignment to role'
            from university_department_roles dr3
            where dr3.department_name = dr.department_name
            and dr3.role_name = dr3.role_name
            and dr2.full_name < dr3.full_name
            )
        )
)
/

