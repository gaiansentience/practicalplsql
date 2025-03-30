--macro-random-generator.sql

create or replace function random_generator(
    p_rows in number default 10
    , p_minval number default -1
    , p_maxval in number default 1
    , p_scale in number default 2
    , p_value_alias in dbms_tf.columns_t default null
) return varchar2 sql_macro(table)
is
    l_sql varchar2(1000);
    l_value_alias varchar2(128);
begin
    l_sql := '
        select trunc(dbms_random.value(p_minval, p_maxval), p_scale) as ##VALUE_ALIAS##
        from dual 
        connect by level <= p_rows 
        ';    
        
    l_value_alias := case when p_value_alias is null then 'range_value' else p_value_alias(1) end;
    l_sql := replace(l_sql, '##VALUE_ALIAS##', l_value_alias);
    return l_sql;
end random_generator;
/

--test the macro
select random_value
from random_generator(10, -1, 1, 6)
/
