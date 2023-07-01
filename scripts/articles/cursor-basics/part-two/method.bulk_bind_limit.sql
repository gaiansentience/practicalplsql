--this script relies on the presence of the simple-employees example
set serveroutput on;

Prompt Method: Bulk Bind With Limit Clause
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    type t_emps is table of c_emps%rowtype;
    l_emps t_emps;
begin
    open c_emps;
    
    <<outer>>
    loop
        fetch c_emps bulk collect into l_emps limit 3;
        exit when l_emps.count = 0;
        
        <<inner>>
$if dbms_db_version.version < 21 $then    
        for i in 1..l_emps.count loop
$else
        for i in indices of l_emps loop
$end
            print_employee(l_emps(i).name, l_emps(i).job);
        end loop inner;
        
    end loop outer;
    close c_emps;
end;
/

/* Script Output:
Method: Bulk Bind With Limit Clause
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