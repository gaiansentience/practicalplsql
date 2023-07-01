--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Passing Record From Cursor For Loop, 21c Defining Iterand Type
declare
    type t_emp_record is record (
        name employees.name%type, 
        job employees.job%type);
    procedure local_print(e in t_emp_record)
    is
    begin
        print_employee(e.name, e.job);
    end local_print;
    procedure iterate_cursor
    is
    begin
        for r $if dbms_db_version.version >= 21 $then t_emp_record $end in (
            select e.name, e.job
            from employees e
            order by e.job, e.name    
        ) loop
            local_print(r);
        end loop;
    end iterate_cursor;
begin
    iterate_cursor;
end;
/

/* Script Output:
Method: Cursor For Loop Fails With Dynamic SQL
PLS-00103: Encountered the symbol "select e.name, e.job...
*/