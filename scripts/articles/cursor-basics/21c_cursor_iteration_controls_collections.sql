
prompt 21c populate associative array with explicit cursor object as the iteration control
set serveroutput on;
declare 
    cursor c_emp is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    type t_emp_tab is table of c_emp%rowtype;
    l_emps t_emp_tab;
begin
    l_emps := t_emp_tab(
        for r in c_emp 
        sequence => r);
    
    for i in indices of l_emps loop
        print_employee(l_emps(i).name);
    end loop;
end;
/

prompt cursor iteration controls to populate associative array indexed by pls_integer
prompt collection iteration control used to copy to index by varchar2 associative array
set serveroutput on;
declare 
    cursor c_emp is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';  
        
    type t_emp_tab is table of c_emp%rowtype index by pls_integer;
    type t_emp_tab_vc is table of c_emp%rowtype index by employees.name%type;
    l_emps t_emp_tab;
    l_emps_vc t_emp_tab_vc;
begin
    l_emps := t_emp_tab(
        for r in c_emp 
        sequence => r);
        
    l_emps_vc := t_emp_tab_vc(
        for v in values of l_emps 
        index v.name => v);
    
    for i, v in pairs of l_emps_vc loop
        print_employee(i, v.job);
    end loop;
end;
/

prompt cursor iteration controls can directly populate associative arrays indexed by varchar2
set serveroutput on;
declare 
    cursor c_emp is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    type t_emp_tab_vc is table of c_emp%rowtype index by employees.name%type;
    l_emps t_emp_tab_vc;
begin
    l_emps := t_emp_tab_vc(
        for r in c_emp 
        index r.name => r);
    
    for i, v in pairs of l_emps loop
        print_employee(i, v.job);
    end loop;
end;
/

prompt 21c populate associative array with explicit cursor object as the iteration control
prompt using multiple cursor iteration controls
set serveroutput on;
declare 
    cursor c_managers is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    cursor c_supporters is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_SUPPORT';   
        
    type t_emp_tab is table of c_managers%rowtype;
    l_emps t_emp_tab;
begin
    l_emps := t_emp_tab(
        for r in c_managers, c_supporters 
        sequence => r);
    
    for i, v in pairs of l_emps loop
        print_employee(v.name, v.job);
    end loop;
end;
/

prompt multiple cursor iteration controls with parameterized explicit cursor objects
set serveroutput on;
declare 
    cursor c_emp(p_job in varchar2) is
        select e.name, e.job
        from employees e
        where e.job = p_job;
        
    type t_emp_tab is table of c_emp%rowtype;
    l_emps t_emp_tab;
begin
    l_emps := t_emp_tab(
        for r in 
            c_emp('SALES_MGR'), 
            c_emp('SALES_SUPPORT') 
        sequence => r);
    
    for v in values of l_emps loop
        print_employee(v.name, v.job);
    end loop;
end;
/


Prompt cursor for loop with implicit cursor object as the iteration control
set serveroutput on;
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_tab is table of t_emp_rec;
    l_emps t_emp_tab;
begin
    l_emps := t_emp_tab(
        for r in (    
            select e.name, e.job
            from employees e
            where e.job = 'SALES_MGR')
        sequence => r);
        
    for i in indices of l_emps loop
        print_employee(l_emps(i).name);
    end loop;
end;
/

prompt cursor variable (strongly typed ref cursor) uses implicit iterator
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_tab is table of t_emp_rec;
    l_emps t_emp_tab;    
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emp t_emp_cur;
begin
    open c_emp for
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    l_emps := t_emp_tab(
        for r in c_emp 
        sequence => r);

    close c_emp;
    
    for i in indices of l_emps loop
        print_employee(l_emps(i).name);
    end loop;
end;
/

prompt cursor variable (weakly typed ref cursor) and iterator record type specified
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_tab is table of t_emp_rec;
    l_emps t_emp_tab;    
    c_emp sys_refcursor;
begin
    open c_emp for
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    l_emps := t_emp_tab(
        for r t_emp_rec in c_emp 
        sequence => r);

    close c_emp;
    
    for i in indices of l_emps loop
        print_employee(l_emps(i).name);
    end loop;    
end;
/

prompt dynamic sql with cursor variable and iterator record type specified
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_tab is table of t_emp_rec;
    l_emps t_emp_tab;    
    c_emp sys_refcursor;
    l_sql varchar2(100);
begin
    l_sql := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'    
    ]';
    open c_emp for l_sql;

    l_emps := t_emp_tab(
        for r t_emp_rec in c_emp 
        sequence => r);

    close c_emp;
    
    for v in values of l_emps loop
        print_employee(v.name);
    end loop;
end;
/

prompt dynamic sql with implicit cursor variable and iterator record type specified
declare
    type t_emp_rec is record(name employees.name%type, job employees.job%type);
    type t_emp_tab is table of t_emp_rec;
    l_emps t_emp_tab;    
    l_sql varchar2(100);
begin
    l_sql := q'[
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'    
    ]';

    l_emps := t_emp_tab(
        for r t_emp_rec in (
            execute immediate l_sql) 
        sequence => r);
    
    for i in indices of l_emps loop
        print_employee(l_emps(i).name);
    end loop;
end;
/