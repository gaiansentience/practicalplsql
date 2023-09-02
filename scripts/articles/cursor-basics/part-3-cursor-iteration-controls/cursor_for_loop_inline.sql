--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Method: Cursor For Loop with inline dynamic sql
declare
    l_sql varchar2(1000);
begin

    l_sql := 
        'select e.name, e.job
        from employees e
        fetch first 3 rows only';

    for r_emp in l_sql loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
    
end;
/

/* Script Output:
Error report -
ORA-06550: line 10, column 18:
PLS-00456: item 'L_SQL' is not a cursor
*/