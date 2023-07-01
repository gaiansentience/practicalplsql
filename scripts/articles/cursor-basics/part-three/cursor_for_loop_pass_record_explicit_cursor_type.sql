--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Passing Record From Cursor For Loop, Defining Explicit Cursor Return Type
declare
    type t_emp_record is record (
        name employees.name%type, 
        job employees.job%type);
    cursor c return t_emp_record is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    procedure local_print(e in t_emp_record)
    is
    begin
        print_employee(e.name, e.job);
    end local_print;
    procedure iterate_cursor
    is
    begin
        for r in c loop
            local_print(r);
        end loop;
    end iterate_cursor;
begin
    iterate_cursor;
end;
/

/* Script Output:
Passing Record From Cursor For Loop, Defining Explicit Cursor Return Type
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
Alex SALES_REP
Jane SALES_REP
John SALES_REP
Julie SALES_REP
Sarah SALES_REP
George SALES_SUPPORT
Martin SALES_SUPPORT
Thomas SALES_SUPPORT
*/