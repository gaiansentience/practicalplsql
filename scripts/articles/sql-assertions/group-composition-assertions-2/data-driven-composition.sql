select user;

select user, banner_full from v$version;

select * from user_tables;

drop assertion if exists department_max_paired_roles_not_exceeded;
drop assertion if exists department_unique_roles_are_not_duplicated;
drop assertion if exists department_has_all_required_roles;
drop assertion if exists department_has_all_required_role_dependencies;
drop table if exists university_department_roles purge;
drop table if exists university_departments purge;
drop table if exists university_cross_role_dependencies purge;
drop table if exists university_role_types purge;


create table if not exists university_role_types (
role_name varchar2(50) constraint university_role_types_pk primary key,
is_required boolean default false, --at least one... ie, must have faculty
is_unique boolean default false,  --only one... at most one admin
max_paired boolean default false --at most two.. at most co-chairs
)
/

--if a then b is required...  if interns then fellows, if admin then assistant

--if a then b:  intern, fellow,  admin,assistant
create table if not exists university_cross_role_dependencies(
role_name varchar2(50) not null references university_role_types,
required_role_name varchar2(50) not null references university_role_types,
constraint university_cross_role_dependencies_pk
    primary key (role_name, required_role_name)
)
/

--does not handle these cases:
--role a or b is required ..admin or secretary required - role_subsitutability
--staff limit is two roles in a department

create table if not exists university_departments (
department_name varchar2(50) constraint university_departments_pk primary key
)
/


create table if not exists university_department_roles(
department_name references university_departments,
role_name references university_role_types,
full_name varchar2(50),
constraint university_department_roles_pk 
    primary key (department_name, role_name, full_name)
)
/





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


insert into university_role_types(role_name, is_required, is_unique, max_paired)
values ('faculty', true, false, false),('chair', false, false, true)
,('admin', true, true, false),('secretary', false, false, false),('assistant', false, false, false)
,('fellow',false,false,false),('intern',false,false,false)
/

commit;

insert into university_cross_role_dependencies(role_name, required_role_name)
values ('admin','assistant'),('intern','fellow')
/

commit;
