declare
    l_options varchar2(100);
    l_task varchar2(100);
begin
    l_options := 'There are several approaches to this query, are they equivalent?';
    dbms_output.put_line(l_options);
    l_task := 'Can I see how Oracle will interpret each query?';
    dbms_output.put_line(l_task);
end;