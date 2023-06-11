--this script uses objects from examples\simple-employees
set serveroutput on;

prompt ref cursor with dynamic sql, column not in select list
set serveroutput on;
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
    c_emp sys_refcursor;
    r_emp t_emp_rec;
begin

    open c_emp for 
        'select e.name
        from employees e
        order by e.job, e.name';

        fetch c_emp into r_emp;

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script Output:
ref cursor with dynamic sql, column not in select list
ORA-01007: variable not in select list
*/