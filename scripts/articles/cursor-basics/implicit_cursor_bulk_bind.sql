prompt implicit cursor bulk bind
declare
    type t_emp_rec is record (
        name pp_employees.name%type, 
        job pp_employees.job%type);
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
begin

    select e.name, e.job
    bulk collect into l_emps
    from pp_employees e
    order by e.job, e.name;
    
    
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
end;
/
