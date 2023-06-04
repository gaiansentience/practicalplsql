@@print_boolean.pls;

declare
    cursor c is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name
        fetch first 2 rows only;
    r_emp c%rowtype;
begin
    print_boolean(c%isopen,'c%isopen');
    open c;
    print_boolean(c%isopen,'c%isopen');

    fetch c into r_emp;
    dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
    fetch c into r_emp;
    dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
end;
/
--(c%isopen is false)
--(c%isopen is true)
--Gina SALES_EXEC
--Ann SALES_MGR

declare
    cursor c is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name
        fetch first 2 rows only;
    r_emp c%rowtype;
begin
    open c;
    fetch c into r_emp;
    dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
    print_boolean(c%notfound, 'c%notfound');
    
    fetch c into r_emp;
    dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
    print_boolean(c%notfound, 'c%notfound');
    
    dbms_output.put_line('fetch after all records have been fetched');
    fetch c into r_emp;
    dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
    print_boolean(c%notfound, 'c%notfound');
    
end;
/
--Gina SALES_EXEC
--(c%notfound is false)
--Ann SALES_MGR
--(c%notfound is false)
--fetch after all records have been fetched
--Ann SALES_MGR
--(c%notfound is true)
