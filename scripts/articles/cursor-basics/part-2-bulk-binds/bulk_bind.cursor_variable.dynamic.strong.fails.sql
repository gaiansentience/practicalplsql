--this script relies on the presence of the simple-employees example
set serveroutput on;

Prompt Strongly Typed Cursor Variable Bulk Bind using Dynamic Sql Fails
declare
    type t_emp_rec is record(
        name employees.name%type, 
        job employees.job%type);
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emps t_emp_cur;
    type t_emps is table of t_emp_rec;
    l_emps t_emps;
    l_sql varchar2(100);
begin
    l_sql := '
        select e.name, e.job
        from employees e
        order by e.job, e.name';
        
    open c_emps for l_sql;
    fetch c_emps bulk collect into l_emps;
    close c_emps;
    
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
Strongly Typed Cursor Variable Bulk Bind using Dynamic Sql Fails
PLS-00455: cursor 'C_EMPS' cannot be used in dynamic SQL OPEN statement
*/