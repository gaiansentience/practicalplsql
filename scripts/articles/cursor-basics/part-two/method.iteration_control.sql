set serveroutput on;
prompt this script relies on the presence of the simple-employees example


Prompt Method: 21c Cursor Iteration Controls
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    type t_emps is table of c_emps%rowtype;
    l_emps t_emps;
begin

$if dbms_db_version.version < 21 $then
    dbms_output.put_line('method introduced in Oracle 21');
$else
    l_emps := t_emps(for r in c_emps sequence => r);
    for i in indices of l_emps loop
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
$end

end;
/

/* Script Output:
Method: 21c Cursor Iteration Controls
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