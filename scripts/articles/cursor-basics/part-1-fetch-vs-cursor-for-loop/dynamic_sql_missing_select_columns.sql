--this script uses objects from examples\simple-employees
set serveroutput on;

prompt ref cursor with dynamic sql, column not in select list
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
    c_emp sys_refcursor;
    r_emp t_emp_rec;
    l_sql varchar2(100);
begin
    l_sql :=
        'select e.name
        from employees e
        order by e.job, e.name';

    open c_emp for l_sql;

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