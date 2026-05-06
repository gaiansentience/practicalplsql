insert into job_roles_dv (data)
set data = json{'_id' : 'AUTHOR', 'min_salary' : 0, 'max_salary' : 1e7}
/

insert into job_roles_dv (data)
set data = json{'_id' : 'EDITOR', 'min_salary' : 1e4, 'max_salary' : 1e6}
/

update job_roles_dv d
set d.data = json_transform(data, set '$.min_salary' = 5e2)
--where json_value(data, '$._id') = 'AUTHOR'
where d.data."_id" = 'AUTHOR'
/

commit;


insert into employees_dv (data)
set data = json{'first_name' value 'Isaac', 'last_name' value 'Asimov', 'job_role' value 'AUTHOR', 'salary' value 1}
/

insert into employees_dv (data)
set data = json{'first_name' value 'Edwin', 'last_name' value 'Albie', 'job_role' value 'EDITOR', 'salary' value 1.12e4}
/

commit;

select * from job_roles_dv;

select *
from job_roles_dv d
where d.data."_id" = 'AUTHOR';

select * from employees_dv;

select *
from employees_dv d
where d.data.first_name = 'Isaac';