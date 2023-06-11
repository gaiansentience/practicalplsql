set serveroutput on;
prompt this script relies on the presence of the simple-employees example

Prompt Method: Bulk Bind
declare
    cursor c_emps is
         select e.name, e.job
         from employees e
         order by e.job, e.name;
    type t_emps is table of c_emps%rowtype;
    l_emps t_emps;
begin
    open c_emps;
    fetch c_emps bulk collect into l_emps;
    close c_emps;
    
$if dbms_db_version.version < 21 $then    
    for i in 1..l_emps.count loop
$else
    for i in indices of l_emps loop
$end
        dbms_output.put_line(l_emps(i).name || ' ' || l_emps(i).job);
    end loop;
end;
/

/* Script Output:
Method: Bulk Bind
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