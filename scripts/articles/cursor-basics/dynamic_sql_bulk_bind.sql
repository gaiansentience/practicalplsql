prompt explicit ref cursor (weakly typed) bulk bind with dynamic sql
declare
    c_emp sys_refcursor;
    type t_emp_rec is record (
        name pp_employees.name%type, 
        job pp_employees.job%type);
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
begin
    open c_emp for 
    'select e.name, e.job
    from pp_employees e
    order by e.job, e.name';
    
    fetch c_emp bulk collect into l_emps;
    close c_emp;
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

prompt explicit ref cursor (strongly typed) bulk bind with dynamic sql
declare
    type t_emp_rec is record (
        name pp_employees.name%type, 
        job pp_employees.job%type);
    type t_cur_emp is ref cursor return t_emp_rec;
    c_emp t_cur_emp;
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
begin
    open c_emp for 
    'select e.name, e.job
    from pp_employees e
    order by e.job, e.name';
    
    fetch c_emp bulk collect into l_emps;
    close c_emp;
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--PLS-00455: cursor 'C_EMP' cannot be used in dynamic SQL OPEN statement