--temporal validity


create table salary_history(
emp_id number references emps(emp_id),
salary number,
start_date date,
end_date date,
primary key (emp_id, start_date)
)
/


--check constraint
alter table salary_history
add constraint salary_history_ck_dates
check (start_date < end_date)
/



--use temporal period (system defined start/end as invisible columns)
alter table salary_history
add period for salaries
/


--temporal period using user defined columns
alter table salary_history
add period for salaries (start_date, end_date)
/


select *
from salary_history
where start_date <= sysdate and (end_date is null or end_date > sysdate)
/


select *
from salary_history
as of period for salaries sysdate
/



---multi dimensional temporal validity

---add table for job_history 




--get job_role and salary as of the same date