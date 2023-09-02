create or replace view employee_info as
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
    employees e,
    job_info j,
    department_info d,
    employees m,
    location_info l
where
    e.job_id = j.job_id
    and e.department_id = d.department_id
    and e.manager_id = m.id(+)
    and e.location_id = l.location_id(+);