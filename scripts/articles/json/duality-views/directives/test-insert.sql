set serveroutput on;

insert into job_roles_dv (data)
set data = json{'job_role' : 'AUTHOR', 'min_salary' : 5e2, 'max_salary' : 25e3}
/

insert into job_roles_dv (data)
set data = json{'job_role' : 'EDITOR', 'min_salary' : 1e4, 'max_salary' : 1e6}
/

insert into job_roles_dv (data)
set data = json{'job_role' : 'CLERK', 'min_salary' : 1e2, 'max_salary' : 1e4}
/


update job_roles_dv d
set d.data = json_transform(data, set '$.min_salary' = 5e2, set '$.max_salary' = 25e3)
--where json_value(data, '$._id') = 'AUTHOR'
where d.data."job_role" = 'AUTHOR'
/

update job_roles_dv d
set d.data = json_transform(data, set '$.min_salary' = 25e2)
--where json_value(data, '$._id') = 'AUTHOR'
where d.data."job_role" = 'AUTHOR'
/


commit;

insert into employees_dv (data)
set data = json{ '_id' value {'first_name' value 'Larry', 'last_name' value 'Niven'},'job_role' value 'CLERK', 'salary' value 125}
/

insert into employees_dv (data)
set data = json{'first_name' value 'Isaac', 'last_name' value 'Asimov','role' value {'job_role' value 'AUTHOR'}, 'salary' value 525}
/

insert into employees_dv (data)
set data = json{'_id' value {'first_name' value 'Edwin', 'last_name' value 'Albie'}, 'job_role' value 'EDITOR', 'salary' value 1.12e5}
/

update employees_dv d
set data = json_transform(data, set '$.salary' = path '7e4', set '$.job_role' = 'AUTHOR')
where d.data."_id".first_name = 'Larry' and d.data."_id".last_name = 'Niven'
/

commit;

select * from job_roles_dv;

select *
from job_roles_dv d
where d.data."job_role" = 'AUTHOR';

select json_transform(data, remove '$._metadata' returning varchar2 pretty) from employees_dv;

select *
from employees_dv d
where d.data.first_name = 'Isaac';

select * from employees;

delete employees;