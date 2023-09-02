create or replace view employee_info_ansi as
select
    e.first_name || ' ' || e.last_name as employee
    , e.last_name || ', ' || e.first_name as employee_sort
    , e.email
    , j.job_name
    , d.department_name
    , e.salary
    , nvl(l.location_name, 'Unassigned') as location
    , nvl(m.first_name || ' ' || m.last_name, 'No Manager') as manager
from
    employees e
    left outer join employees m on e.manager_id = m.id
    join job_info j on e.job_id = j.job_id
    join department_info d on e.department_id = d.department_id
    left outer join location_info l on e.location_id = l.location_id;