set serveroutput on;

declare
    l_goal varchar2(100) := 'dynamic unpivot';
    l_problem varchar2(100) := 'custom code for every query';
    l_solution varchar2(100) := 'json_table and json_dataguide';
begin
    dbms_output.put_line('For ' || l_goal);
    dbms_output.put_line('Use ' || l_solution || ' to eliminate ' || l_problem);   
end;
/