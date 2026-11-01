
drop assertion if exists department_max_paired_roles_not_exceeded;
drop assertion if exists department_unique_roles_are_not_duplicated;
drop assertion if exists department_has_all_required_roles;
drop assertion if exists department_has_all_required_role_dependencies;
drop table if exists university_department_roles purge;
drop table if exists university_departments purge;
drop table if exists university_cross_role_dependencies purge;
drop table if exists university_role_types purge;
drop usecase domain if exists domain_name_key;
