
--use examples/simple-hr

--title-code.sql

select 
    l.name as location_name
    , d.name as department_name
    , j.name as job_name
    , count(*) as count_employees
    , sum(e.salary) as sum_salary
    , avg(e.salary) as avg_salary
    , min(e.salary) as min_salary
    , max(e.salary) as max_science 
from 
    employees e 
    join departments d on e.department_id = d.id
    join locations l on e.location_id = l.id
    join jobs j on e.job_id = j.id
order by location_name, department_name, job_name
/


/*
ORA-00937: not a single-group group function

https://docs.oracle.com/error-help/db/ora-00937/00937. 00000 -  "not a single-group group function"
*Cause:    A SELECT list cannot include both a group function,
           such as AVG, COUNT, MAX, MIN, SUM, STDDEV, or VARIANCE, and an
           individual column expression, unless the individual column
           expression was included in a GROUP BY clause.
*/

--group by source columns
select 
    l.name as location_name
    , d.name as department_name
    , listagg(distinct j.code, ', ') within group (order by j.code) as job_codes
    , count(*) as count_employees
    , sum(e.salary) as sum_salary
    , round(avg(e.salary)) as avg_salary
    , min(e.salary) as min_salary
    , max(e.salary) as max_salary
from 
    employees e 
    join departments d on e.department_id = d.id
    left outer join locations l on e.location_id = l.id
    join jobs j on e.job_id = j.id
group by l.name, d.name
order by location_name, department_name
/

--group by alias
select 
    l.name as location_name
    , d.name as department_name
    , listagg(distinct j.code, ', ') within group (order by j.code) as job_codes
    , count(*) as count_employees
    , sum(e.salary) as sum_salary
    , round(avg(e.salary)) as avg_salary
    , min(e.salary) as min_salary
    , max(e.salary) as max_salary
from 
    employees e 
    join departments d on e.department_id = d.id
    left outer join locations l on e.location_id = l.id
    join jobs j on e.job_id = j.id
group by location_name, department_name
order by location_name, department_name
/

--group by ALL (23.9)
select 
    l.name as location_name
    , d.name as department_name
    , listagg(distinct j.code, ', ') within group (order by j.code) as job_codes
    , count(*) as count_employees
    , sum(e.salary) as sum_salary
    , round(avg(e.salary)) as avg_salary
    , min(e.salary) as min_salary
    , max(e.salary) as max_salary
from 
    employees e 
    join departments d on e.department_id = d.id
    left outer join locations l on e.location_id = l.id
    join jobs j on e.job_id = j.id
group by all
order by location_name, department_name
/


--using group by ALL as prototyping tool
--no aggregates, group by all columns
select e.*
from employees e
group by all
/

select 
    e.location_id
    , sum(e.salary) as group_salary
from employees e
group by all
/

select 
    e.department_id
    , sum(e.salary) as group_salary
from employees e
group by all
/

select 
    e.job_id
    , sum(e.salary) as group_salary
from employees e
group by all
/

select 
    e.job_id
    , j.name as job_name
    , sum(e.salary) as group_salary
from 
    employees e
    join jobs j on e.job_id = j.id
group by all
/

select 
    e.job_id
    , any_value(j.name) as job_name
    , sum(e.salary) as group_salary
from 
    employees e
    join jobs j on e.job_id = j.id
group by all
/

select 
    e.location_id
    , l.name as location_name
    , listagg(distinct d.name, ', ') within group (order by d.name) as department_name
    , sum(e.salary) as group_salary
from 
    employees e
    join departments d on e.department_id = d.id
    left outer join locations l on e.location_id = l.id
group by all
order by location_name nulls first, department_name
/

