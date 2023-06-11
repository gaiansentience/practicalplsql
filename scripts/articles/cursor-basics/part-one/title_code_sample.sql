declare
    l_task varchar2(100);
    cursor c is
    select level as n
    from dual
    connect by level <= 10;
begin
    l_task := 'print all the rows of explicit cursor c to output';
    dbms_output.put_line(l_task);
end;
/