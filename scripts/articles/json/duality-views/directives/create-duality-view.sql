create or replace json relational duality view employees_dv as
select
    json {
       -- '_id' : e.id
        '_id' : { 'first_name' : e.first_name, 'last_name'  : e.last_name}
        , unnest (
            select json {
                'role_id' : r.id hidden, 
                'job_role' : r.job_role
                , 'min_salary' : r.min_salary
                , 'max_salary' : r.max_salary
                }
            from job_roles r with noinsert noupdate nodelete
            where r.id = e.job_role_id
        )
        , 'salary' : e.salary
--        , 'dml_notes' : e.dml_notes generated on write using 
--            path '$.salary' 
--            hidden
       -- , 'job_role_id' : e.job_role_id generated on write using path '$.role_id' hidden
        }
from employees e  with insert update delete
/

--duality view directives... ??no dml

--insert employee, job_code xxxx

--employee dv   emp job_code   +read_augmented job.min_sal, job.max_sal
--how can validation directive on insert of new employee confirm salary range is valid?


---insert employee  job=clerk   --is clerk.min_sal visible on insert?

select * from employees_dv;


create or replace json relational duality view job_roles_dv as
select
    json {
       -- '_id' : r.id
       '_id' : { 'job_role' : r.job_role}
        , 'min_salary' : r.min_salary
        , 'max_salary' : r.max_salary
        }
from job_roles r with insert update delete
/



select * from user_objects
where object_type = 'SYNONYM';

select * from user_json_duality_view_tab_cols
where view_name = 'EMPLOYEES_DV';