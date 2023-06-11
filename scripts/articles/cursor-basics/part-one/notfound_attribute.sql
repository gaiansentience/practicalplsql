set serveroutput on;
prompt %notfound attribute
declare
    cursor c_emp is
        select e.name, e.job
        from employees e
        order by e.job, e.name
        fetch first 2 rows only;
    r_emp c_emp%rowtype;
begin
    open c_emp;

    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);
    print_boolean_attribute(c_emp%notfound, 'c_emp%notfound');
    
    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);
    print_boolean_attribute(c_emp%notfound, 'c_emp%notfound');
    
    dbms_output.put_line('fetch after all records have been fetched');
    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);
    print_boolean_attribute(c_emp%notfound, 'c_emp%notfound');
    
end;
/
/* Script Output:
%notfound attribute
Gina SALES_EXEC
(c_emp%notfound is false)
Ann SALES_MGR
(c_emp%notfound is false)
fetch after all records have been fetched
Ann SALES_MGR
(c_emp%notfound is true)
*/