set serveroutput on;

declare
    l_row_differences boolean := true;
    l_next_step varchar2(100);
begin
    if l_row_differences then
        l_next_step := 'unpivot to show column differences';
        dbms_output.put_line(l_next_step);
    end if;
end;
/