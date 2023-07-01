--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt cursor For Loop with Dynamic SQL, Undefined Iterand Type
declare
    type t_emp_record is record (
        name employees.name%type, 
        job employees.job%type);

    l_sql varchar2(100) :=
        'select e.name, e.job
        from employees e';
begin

$if dbms_db_version.version >= 21 $then
    for r in (execute immediate l_sql) loop
        print_employee(r.name, r.job);
    end loop;
$else
    dbms_output.put_line('For loop incompatible with dynamic SQL Before 21c');
$end

end;
/

/* Script Output:
21c cursor For Loop with Dynamic SQL, Undefined Iterand Type
PLS-00858: No iterand type was specified for an EXECUTE IMMEDIATE iteration control.
*/