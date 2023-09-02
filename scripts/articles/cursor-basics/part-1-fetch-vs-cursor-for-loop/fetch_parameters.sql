--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch parameterized cursor, close before reopening
declare
    cursor c_emp(p_job in varchar2) is
        select e.name, e.job
        from employees e
        where e.job = p_job;
    r_emp c_emp%rowtype;
begin

    dbms_output.put('print a sales manager: ');
    open c_emp('SALES_MGR');
    fetch c_emp into r_emp;
    print_employee(r_emp.name);
    close c_emp;
    
    dbms_output.put('print a sales executive: ');
    open c_emp('SALES_EXEC');    
    fetch c_emp into r_emp;
    print_employee(r_emp.name);
    close c_emp;

end;
/

/* Script Output:
fetch parameterized cursor, close before reopening
print a sales manager: Ann
print a sales executive: Gina
*/