--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Cursor Object is an explicit cursor
declare
    cursor c_cursor_object is
        select e.name, e.job
        from employees e
        fetch first 3 rows only;    
begin
    open c_cursor_object;
    
    for r_iterand in c_cursor_object loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
    close c_cursor_object;
end;
/

/* Script Output:
Method: Cursor For Loop with explicit cursor
Error report -
ORA-06511: PL/SQL: cursor already open
...
*Cause:    An attempt was made to open a cursor that was already open.
*Action:   Close cursor first before reopening.
*/