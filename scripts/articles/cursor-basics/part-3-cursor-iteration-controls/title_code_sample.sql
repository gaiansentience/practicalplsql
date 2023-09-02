declare
    l_task varchar2(100);
    type t_emp_rec is record(
        name varchar2(50), 
        job varchar2(50));
    type t_emp_cur is ref cursor return t_emp_rec;
    c t_emp_cursor;
    rc sys_refcursor;
begin
    l_task := 'use a for loop to iterate the rows of a ref cursor';
    dbms_output.put_line(l_task);
end;