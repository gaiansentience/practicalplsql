--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Use implicit cursor to fetch a single record
declare
    cursor c_rep_count is
        select count(*) as emp_count
        from employees e
        where e.job = 'SALES_REP';
    l_sales_reps number;
begin

    dbms_output.put_line('using explicit cursor for one row');
    open c_rep_count;
    fetch c_rep_count into l_sales_reps;
    dbms_output.put_line(l_sales_reps || ' sales representatives found');
    close c_rep_count;

    dbms_output.put_line('using implicit cursor for one row');
    select count(*) into l_sales_reps
    from employees e
    where e.job = 'SALES_REP';
    dbms_output.put_line(l_sales_reps || ' sales representatives found');

end;
/

/* Script Output:
Use implicit cursor to fetch a single record
using explicit cursor for one row
5 sales representatives found
using implicit cursor for one row
5 sales representatives found
*/
