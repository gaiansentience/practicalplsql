create usecase domain if not exists domain_name_key 
    as varchar2(50) not null
/



create table if not exists university_role_types (
role_name domain_name_key constraint university_role_types_pk primary key,
is_required boolean default false, --at least one... ie, must have faculty
is_unique boolean default false,  --only one... at most one admin
max_paired boolean default false --at most two.. at most co-chairs
)
/

--if a then b is required...  if interns then fellows, if admin then assistant

--if a then b:  intern, fellow,  admin,assistant
create table if not exists university_cross_role_dependencies(
role_name domain_name_key references university_role_types,
required_role_name domain_name_key references university_role_types,
constraint university_cross_role_dependencies_pk
    primary key (role_name, required_role_name)
)
/

--does not handle these cases:
--role a or b is required ..admin or secretary required - role_subsitutability
--staff limit is two roles in a department

create table if not exists university_departments (
department_name domain_name_key constraint university_departments_pk primary key
)
/


create table if not exists university_department_roles(
department_name domain_name_key references university_departments,
role_name domain_name_key references university_role_types,
full_name domain_name_key not null,
constraint university_department_roles_pk 
    primary key (department_name, role_name, full_name)
)
/


