create table employees (
    id number generated always as identity 
        constraint employees_pk primary key
    , first_name varchar2(50)
    , middle_name varchar2(50)
    , last_name varchar2(50)
    , email varchar2(100) 
        constraint employees_email_required not null
        constraint employees_email_unique unique
    , job_id number 
        constraint employees_fk_jobs references jobs (id)
    , department_id number 
        constraint employees_fk_departments references departments (id)
    , location_id number 
        constraint employees_fk_locations references locations (id)    
    , manager_id number 
        constraint employees_fk_employees references employees (id)
    , salary number 
        constraint employees_salary_positive check (salary > 0)
    , hire_date date
    , constraint employees_name_required check(coalesce(first_name,last_name, middle_name) is not null)
)
/

