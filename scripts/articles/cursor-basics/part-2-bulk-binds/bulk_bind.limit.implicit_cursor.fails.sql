--this script relies on the presence of the simple-employees example
set serveroutput on;

Prompt Implicit Cursor Bulk Bind with Limit Fails
declare
    type t_emp_rec is record(
        name employees.name%type, 
        job employees.job%type);
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
begin
    select e.name, e.job
    bulk collect into l_emps limit 3
    from employees e
    order by e.job, e.name;
end;
/

/* Script Output:
PL/SQL: ORA-00923: FROM keyword not found where expected
*/