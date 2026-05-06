create or replace json relational duality view employees_dv as
select
    json {
        '_id' : e.id
        , 'first_name' : e.first_name
        , 'last_name'  : e.last_name
        , 'job_role'   : e.job_role
        , 'salary' : e.salary
        }
from employees e with insert update delete
/


create or replace json relational duality view job_roles_dv as
select
    json {
        '_id' : r.job_role
        , 'min_salary' : r.min_salary
        , 'max_salary' : r.max_salary
        }
from job_roles r with insert update delete
/



