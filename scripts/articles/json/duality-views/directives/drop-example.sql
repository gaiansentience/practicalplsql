drop package if exists employee_api;
drop view if exists employees_dv;
drop view if exists job_roles_dv;
drop directive if exists new_employees_minimum_salary;
drop assertion if exists employee_salary_in_job_role_range;
drop table if exists employees purge;
drop table if exists job_roles purge;
drop domain if exists person_full_name_d;


