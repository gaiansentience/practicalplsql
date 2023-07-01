

prompt multiple cursor iteration controls: explicit cursor objects
set serveroutput on;
declare 
    cursor c_managers is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';  
        
    cursor c_support is
        select e.name, e.job
        from employees e
        where e.job = 'SUPPORT';
begin
    for r in c_managers, c_support loop
        print_employee(r.name, r.job);
    end loop;
end;
/

prompt multiple cursor iteration controls: parameterized explicit cursor object
set serveroutput on;
declare 
    cursor c_emp(p_job in varchar2) is
        select e.name, e.job
        from employees e
        where e.job = p_job;
begin
    for r in 
        c_emp('SALES_MGR'), 
        c_emp('SALES_SUPPORT') 
    loop
        print_employee(r.name, r.job);
    end loop;
end;
/

prompt cursor for loop with inline sql is an implicit cursor object
prompt multiple cursor iteration controls with implicit cursor objects
set serveroutput on;
begin
    for r in (
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'
        ),(
        select e.name, e.job
        from employees e
        where e.job = 'SALES_SUPPORT'
        ) 
    loop
        print_employee(r.name, r.job);
    end loop;
end;
/

prompt cursor variable (strongly typed ref cursor) uses implicit iterator
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emp t_emp_cur;
begin
    open c_emp for
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    for r in c_emp loop
        print_employee(r.name);
    end loop;
    
    close c_emp;
end;
/

prompt cursor variable (weakly typed ref cursor) and iterator record type specified
declare
    c sys_refcursor;
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
begin
    open c for
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    for r t_emp_rec in c loop
        print_employee(r.name);
    end loop;
    
    close c;
end;
/

prompt dynamic sql with cursor variable and iterator record type specified
declare
    c sys_refcursor;
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    l_sql varchar2(100);
begin
    l_sql := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'    
    ]';
    
    open c for l_sql;
    
    for r t_emp_rec in c loop
        print_employee(r.name);
    end loop;
    
    close c;
end;
/

prompt dynamic sql with implicit cursor variable and iterator record type specified
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    l_sql varchar2(100);
begin
    l_sql := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'    
    ]';

    for r t_emp_rec in (execute immediate l_sql) loop
        print_employee(r.name);
    end loop;
end;
/

prompt dynamic sql with implicit cursor variable and iterator record type specified
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    l_sql_managers varchar2(200);
    l_sql_support varchar2(200);
begin
    l_sql_managers := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'    
    ]';
    
    l_sql_support := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_SUPPORT'    
    ]';

    for r t_emp_rec in 
        (execute immediate l_sql_managers), 
        (execute immediate l_sql_support) 
    loop
        print_employee(r.name, r.job);
    end loop;
end;
/
