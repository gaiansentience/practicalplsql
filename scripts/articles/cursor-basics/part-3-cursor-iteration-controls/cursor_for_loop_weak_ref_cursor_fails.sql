--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Method: Cursor For Loop with weakly typed ref cursor fails
declare
    type t_emp_rec is record(
        name varchar2(50), 
        job varchar2(20));
    c_emps sys_refcursor;
begin

    open c_emps for
        select e.name, e.job
        from employees e
        fetch first 3 rows only;

    for r_emp in c_emps loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
    
end;
/

/* Script Output:
Fails on any version less than 21 with compiler error
Error report -
ORA-06550: line 14, column 18:
PLS-00221: 'C_EMPS' is not a procedure or is undefined
*/