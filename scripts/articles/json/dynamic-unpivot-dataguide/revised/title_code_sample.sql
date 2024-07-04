set serveroutput on;

declare
    l_goal varchar2(100) := 'dynamic unpivot';
    l_approach varchar2(100) := 'json_table';
    l_problems varchar2(100);
    l_solution varchar2(100);
begin
    if l_goal = 'dynamic unpivot' and l_approach = 'json_table' then
        l_problems := 'hardcoding required for json_table and unpivot';
        l_solution := 'json_dataguide and pipelined functions';
    end if;
    dbms_output.put_line('For ' || l_goal || ' using ' || l_approach);
    dbms_output.put_line('Use ' || l_solution || ' to solve ' || l_problems);   
end;
/