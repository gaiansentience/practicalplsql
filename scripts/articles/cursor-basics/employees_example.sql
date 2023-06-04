@@create_example_employees.sql;

Prompt Method 1: Open, Fetch, Close
declare
    cursor c_emp is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
    type t_emp_rec is record(
        name varchar2(50), job varchar2(50));
    r_emp t_emp_rec;  
    --r_emp c_emp%rowtype
begin
    open c_emp;
    loop
        fetch c_emp into r_emp;
        exit when c_emp%notfound;
        dbms_output.put_line(r_emp.name || ' ' || r_emp.job);
    end loop;
    close c_emp;
exception
    when others then
        if c_emp%isopen then
            close c_emp;
        end if;
        raise;
end;
/

Prompt Method 2: Cursor For Loop
declare
    cursor c_emp is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
begin
    for r in c_emp loop
        dbms_output.put_line(r.name || ' ' || r.job);
    end loop;
end;
/

Prompt Method 3: Bulk Bind
declare
    cursor c_emp is
         select e.name, e.job
         from pp_employees e
         order by e.job, e.name;
    type t_emps is table of c%rowtype;
    l_emps t_emps;
begin
    open c_emp;
    fetch c_emp bulk collect into l_emps;
    close c_emp;
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
end;
/

Prompt Method 4: Bulk Bind With Limit Clause
declare
    cursor c_emp is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
    type t_emps is table of c_emp%rowtype;
    l_emps t_emps;
begin
    open c_emp;
    loop
        fetch c_emp bulk collect into l_emps limit 3;
        exit when l_emps.count = 0;
        for i in indices of l_emps loop
            dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
        end loop;
    end loop;
    close c_emp;
end;
/

Prompt Method 5: 21c Cursor Iteration Controls
declare
    cursor c_emp is
        select e.name, e.job
        from pp_employees e
        order by e.job, e.name;
    type t_emps is table of c_emp%rowtype;
    l_emps t_emps;
begin
    l_emps := t_emps(for r in c_emp sequence => r);
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
end;
/

@@drop_example_employees.sql;