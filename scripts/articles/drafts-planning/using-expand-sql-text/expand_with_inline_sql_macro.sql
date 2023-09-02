set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        with 
        function format_name(p_first in varchar2, p_last in varchar2)
        return varchar2
        sql_macro(scalar)
        is
        begin
            return q'{p_first || ', ' || p_last}';
        end format_name;
        employees_base as 
        (
            select
                format_name(e.first_name, e.last_name) as employee,
                e.id,
                e.manager_id,
                e.job_id
            from employees e
        ) 
        select
            e.employee, 
            m.employee as manager, 
            j.name as job
        from 
            employees_base e,
            employees_base m,
            jobs j
        where
            e.manager_id = m.id (+)
            and e.job_id = j.id
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

--ORA-24256: EXPAND_SQL_TEXT failed with ORA-64630: unsupported use of SQL macro: use of SQL macro inside WITH clause is not supported
