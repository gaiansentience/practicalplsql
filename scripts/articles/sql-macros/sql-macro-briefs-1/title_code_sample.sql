set serveroutput on;
declare
    l_sql varchar2(1000);
    cv sys_refcursor;
    type t_ids is table of number;    
    l_ids t_ids;
begin
    l_sql := q'~
        with 
        function row_generator(p_rows in number)
            return varchar2 sql_macro(table)
        is
        begin
            return 'select level as id from dual connect by level <= p_rows';
        end row_generator;
        select id from row_generator(4)
        ~';
    open cv for l_sql;
    fetch cv bulk collect into l_ids;
    close cv;
    
    for i in 1..l_ids.count loop
        dbms_output.put_line(l_ids(i));
    end loop;
end;
/
