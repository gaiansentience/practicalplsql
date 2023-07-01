--this script relies on the presence of the simple-employees example
set serveroutput on;

Prompt Implicit Cursor Bulk Bind using Dynamic Sql
declare
    type t_emp_rec is record(
        name employees.name%type, 
        job employees.job%type);
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
    l_sql varchar2(100);
begin
    l_sql := '
        select e.name, e.job
        from employees e
        order by e.job, e.name';
        
    execute immediate l_sql bulk collect into l_emps;
    
$if dbms_db_version.version < 21 $then    
    for i in 1..l_emps.count loop
$else
    for i in indices of l_emps loop
$end
        print_employee(l_emps(i).name, l_emps(i).job);
    end loop;
end;
/

/* Script Output:
Implicit Cursor Bulk Bind using Dynamic Sql
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
Alex SALES_REP
Jane SALES_REP
John SALES_REP
Julie SALES_REP
Sarah SALES_REP
George SALES_SUPPORT
Martin SALES_SUPPORT
Thomas SALES_SUPPORT
*/