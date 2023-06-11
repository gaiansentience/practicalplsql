--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Parameterized Cursor For Loop with no declaration
begin
    <<jobs>>
    for r_job in (
        select e.job, count(*) as emp_count
        from employees e
        group by e.job
        order by e.job    
    ) loop
        dbms_output.put_line(r_job.emp_count || ' employees with job = ' || r_job.job);
        
        <<employees>>
        for r_emp in (
            select e.name
            from employees e
            where e.job = r_job.job
            order by e.name        
        ) loop
            print_employee(r_emp.name);
        end loop employees;
        
    end loop jobs;
end;
/

/* Script Output:
Method: Parameterized Cursor For Loop with no declaration
1 employees with job = SALES_EXEC
Gina
2 employees with job = SALES_MGR
Ann
Tobias
5 employees with job = SALES_REP
Alex
Jane
John
Julie
Sarah
3 employees with job = SALES_SUPPORT
George
Martin
Thomas
*/