

create or replace function random_generator(
    p_rows in number default 10
    , p_minval number default -1
    , p_maxval in number default 1
    , p_scale in number default 2
) return varchar2 sql_macro(table)
is
    l_sql varchar2(1000);
begin
    l_sql := '
        select trunc(dbms_random.value(p_minval, p_maxval), p_scale) as random_value
        from dual 
        connect by level <= p_rows 
        ';    
    return l_sql;
end random_generator;
/

--test the macro
select random_value
from random_generator(10, -1, 1, 6)
/
