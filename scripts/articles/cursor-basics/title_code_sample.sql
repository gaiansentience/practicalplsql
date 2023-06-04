declare
    l_text varchar2(100);
    cursor c is
    select level as n
    from dual
    connect by level <= 10;
begin
    select 'print all the rows of explicit cursor c to output'
    into l_text from dual;
    dbms_output.put_line(l_text);
end;
/