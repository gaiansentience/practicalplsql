drop view if exists employees_dv;
drop view if exists job_roles_dv;
drop table if exists employees purge;
drop table if exists job_roles purge;

create table if not exists job_roles (
    id number generated always as identity primary key,
    job_role varchar2(20) not null unique,
    min_salary number not null check (min_salary >= 0),
    max_salary number not null check (max_salary >= 0),
    constraint job_roles_ck_salary_range 
        check (min_salary < max_salary)
)
/

create table if not exists employees (
    id number generated always as identity primary key,
    first_name varchar2(20) not null,
    last_name varchar2(20) not null,
    job_role_id number not null references job_roles(id),
    salary number not null check (salary >= 0),
    constraint employees_u unique (first_name, last_name)
)
/

create or replace json relational duality view job_roles_dv as
select 
    json {
        '_id' : {'job_role' : r.job_role},
        'min_salary' : r.min_salary,
        'max_salary' : r.max_salary
    }
from job_roles r with insert update delete
/

create or replace json relational duality view employees_dv as
select
    json {
        '_id' : {'first_name' : e.first_name, 'last_name' : e.last_name},
        unnest (
            select 
                json {
                    'role_id' : r.id hidden,
                    'job_role' : r.job_role,
                    'min_salary' : r.min_salary,
                    'max_salary' : r.max_salary
                }
            from job_roles r with noinsert noupdate nodelete
            where r.id = e.job_role_id            
        ),
        'salary' : e.salary
    }
from employees e with insert update delete
/


insert into job_roles_dv
set data = json {
    '_id' : {'job_role' : 'CLERK'},
    'min_salary' : 100,
    'max_salary' : 1000
    }
/

insert into job_roles_dv
set data = json {
    '_id' : {'job_role' : 'AUTHOR'},
    'min_salary' : 500,
    'max_salary' : 5000
    }
/

commit;

select * from job_roles_dv;

insert into employees_dv
set data = json {
    '_id' : {'first_name' : 'larry', 'last_name' : 'niven'},
    'job_role' : 'CLERK',
    'salary' : 500
    }
/

insert into employees_dv
set data = json {
    '_id' : {'first_name' : 'isaac', 'last_name' : 'asimov'},
    'job_role' : 'AUTHOR',
    'salary' : 750
    }
/

commit;

select * from employees_dv;