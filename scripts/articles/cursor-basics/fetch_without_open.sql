@@print_boolean.pls;
set serveroutput on;
declare
    cursor c is
        select e.name, e.job
        from pp_employees e;
    r_emp c%rowtype;
begin
    fetch c into r_emp;
exception
    when others then
        dbms_output.put_line(sqlerrm);
        print_boolean(c%isopen, 'c%isopen');
end;
/
--ORA-01001: invalid cursor
--(c%isopen is false)

