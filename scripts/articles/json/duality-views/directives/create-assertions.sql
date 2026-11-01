drop assertion if exists employee_salary_in_job_role_range;

create assertion if not exists employee_salary_in_job_role_range check(
    not exists (
        select 'an employee'
        from employees e
        where exists (
            select 'salary is out of range'
            from job_roles r
            where r.job_role = e.job_role
            and not (e.salary between r.min_salary and r.max_salary)
            )
        )
)
/