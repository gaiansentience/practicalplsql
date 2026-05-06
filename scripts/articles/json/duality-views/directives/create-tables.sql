

create usecase domain if not exists person_full_name_d as (
    first_name as varchar2(100 char),
    last_name  as varchar2(100 char) not null
)
display upper(substr(first_name, 1, 1)) || ' ' || initcap(last_name)
order (last_name || ' ' || first_name)
/

create table if not exists job_roles(
    job_role varchar2(100) not null primary key,
    min_salary number not null
        constraint job_roles_ck_min_salary
        check (min_salary >= 0),
    max_salary number not null
        constraint job_roles_ck_max_salary
        check (max_salary >= 0),
    constraint job_roles_ck_min_salary_valid
        check (min_salary * 1.25 <= max_salary)
)
/


create table if not exists employees(
    id integer generated always as identity primary key,
    first_name varchar2(100),
    last_name varchar2(100),
    job_role varchar2(100) not null
        constraint employees_fk_job_roles
        references job_roles(job_role),
    salary number default 0 not null
        constraint employees_ck_salary_gt_zero
        check (salary > 0)
    domain person_full_name_d (first_name, last_name),
    constraint employees_uk_full_name 
        unique (first_name, last_name)
)
/
