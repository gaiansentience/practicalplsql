--this script uses objects from examples\simple-employees
set serveroutput on;

prompt strongly typed ref cursor with dynamic sql will not compile
set serveroutput on;
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
      type  t_emp_cur is ref cursor return t_emp_rec;
    c_emp t_emp_cur;
    r_emp t_emp_rec;
begin
    open c_emp for 
        'select e.name, e.job
        from employees e
        order by e.job, e.name';
end;
/

/* Script Output:
strongly typed ref cursor with dynamic sql will not compile
PLS-00455: cursor 'C_EMP' cannot be used in dynamic SQL OPEN statement
*/