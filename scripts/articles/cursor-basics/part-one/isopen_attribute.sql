--this script uses objects from examples\simple-employees
set serveroutput on;

prompt %isopen attribute
declare
    cursor c_emp is
        select e.name, e.job
        from employees e;
    r_emp c_emp%rowtype;
begin
    dbms_output.put('before opening the cursor');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    open c_emp;
    dbms_output.put('after opening the cursor');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    close c_emp;
    dbms_output.put('after closing the cursor');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    
    raise program_error;
exception
    when others then
        dbms_output.put_line(sqlerrm);
        print_boolean_attribute(c_emp%isopen, 'c_emp%isopen');
        if c_emp%isopen then
            close c_emp;
        end if;
end;
/

/* Script Output:
%isopen attribute
before opening the cursor(c_emp%isopen is false)
after opening the cursor(c_emp%isopen is true)
after closing the cursor(c_emp%isopen is false)
ORA-06501: PL/SQL: program error
(c_emp%isopen is false)
*/