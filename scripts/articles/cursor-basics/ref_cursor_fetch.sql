prompt strongly typed ref cursor
declare
    type t_emp_rec is record (
        name pp_employees.name%type, 
        job pp_employees.job%type);
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emp t_emp_cur;    
    l_emp t_emp_rec;
begin
    open c_emp for 
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
    loop
        fetch c_emp into l_emp;
        exit when c_emp%notfound;
        dbms_output.put_line(l_emp.name || ' ' || l_emp.job);
    end loop;
    close c_emp;
end;
/

prompt weakly typed ref cursor
declare
    type t_emp_rec is record (
        name pp_employees.name%type, 
        job pp_employees.job%type);
    c_emp sys_refcursor;    
    l_emp t_emp_rec;
begin
    open c_emp for 
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
    loop
        fetch c_emp into l_emp;
        exit when c_emp%notfound;
        dbms_output.put_line(l_emp.name || ' ' || l_emp.job);
    end loop;
    close c_emp;
end;
/