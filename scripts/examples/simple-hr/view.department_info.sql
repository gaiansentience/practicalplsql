create or replace view department_info as
select 
    id as department_id
    , code as department_code
    , name as department_name
    , description as department_description
from departments;
/