declare
    l_task varchar2(100);
    l_goal varchar2(100);
begin
    l_task := 'select rows from source and target that have differences';
    l_goal := 'simplify this task by using pl/sql';

    dbms_output.put_line(l_task);
    dbms_output.put_line(l_goal);
end;
/