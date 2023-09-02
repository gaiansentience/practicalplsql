create table employees (
    id number generated always as identity primary key
    , first_name varchar2(50)
    , last_name varchar2(50)
    , email varchar2(100) not null
        check (email = initcap(email))
    , job_id number not null references jobs (id)
    , department_id number references departments (id)
    , location_id number references locations (id)    
    , manager_id number references employees (id)
    , salary number check (salary > 0)
    , hire_date date
    , constraint employees_email_u unique (email)
);
/
