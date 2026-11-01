drop view if exists employees_dv;
drop view if exists job_roles_dv;
drop table if exists employees purge;
drop table if exists job_roles purge;

create table if not exists job_roles (
    job_role varchar2(20) not null primary key,
    min_salary number not null check (min_salary >= 0),
    max_salary number not null check (max_salary >= 0),
    constraint job_roles_ck_salary_range 
        check (min_salary < max_salary)
)
/

create table if not exists employees (
    first_name varchar2(20) not null,
    last_name varchar2(20) not null,
    job_role not null references job_roles(job_role),
    salary number not null check (salary >= 0),
    constraint employees_pk primary key (first_name, last_name)
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
                    'job_role' : r.job_role,
                    'min_salary' : r.min_salary,
                    'max_salary' : r.max_salary
                }
            from job_roles r with noinsert noupdate nodelete
            where r.job_role = e.job_role            
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

update employees_dv e
set e.data = json_transform(e.data, set '$.salary' = 300)
where e.data."_id".first_name = 'larry' and e.data."_id".last_name = 'niven'
/

commit;

update employees_dv e
set e.data = json_transform(e.data, set '$.job_role' = 'AUTHOR')
where e.data."_id".first_name = 'larry' and e.data."_id".last_name = 'niven'
/


commit;

