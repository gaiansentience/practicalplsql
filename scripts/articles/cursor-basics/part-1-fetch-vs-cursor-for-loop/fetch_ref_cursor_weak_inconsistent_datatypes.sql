--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch from weakly typed ref cursor, inconsistent datatypes
declare
    type t_emp_rec is record (
        name varchar2(50),
        id number,
        hire_date date);
    c_emp sys_refcursor;    
    r_emp t_emp_rec;
begin
    open c_emp for 
        select e.name, sysdate, e.id
        from employees e
        order by e.job, e.name;
    fetch c_emp into r_emp;

exception
    when others then
    dbms_output.put_line(sqlerrm);    
end;
/

/* Script Output:
ORA-00932: inconsistent datatypes: expected NUMBER got DATE
*/