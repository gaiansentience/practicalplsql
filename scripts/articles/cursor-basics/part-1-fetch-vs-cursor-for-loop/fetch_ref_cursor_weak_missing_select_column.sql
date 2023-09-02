--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch from weakly typed ref cursor, missing select columns
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
    c_emp sys_refcursor;    
    r_emp t_emp_rec;
begin
    open c_emp for 
        select e.name
        from employees e
        order by e.job, e.name;
    fetch c_emp into r_emp;
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script Output:
ORA-06504: PL/SQL: Return types of Result Set variables or query do not match
*/