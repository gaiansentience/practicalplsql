--macro-range-generator.sql

create or replace function range_generator(
    p_rows in number default 100
    , p_offset number default 1
    , p_increment in number default 1
    , p_value_alias in dbms_tf.columns_t default null
) return varchar2 sql_macro(table)
is
    l_sql varchar2(1000);
    l_value_alias varchar2(128);
begin
    
    l_sql := '
        select p_offset + ((level - 1) * p_increment) as ##VALUE_ALIAS##
        from dual 
        connect by level <= p_rows 
        ';   
    
    l_value_alias := case when p_value_alias is null then 'range_value' else p_value_alias(1) end;
    l_sql := replace(l_sql, '##VALUE_ALIAS##', l_value_alias);
    return l_sql;
end range_generator;
/

--test the macro
select *
from range_generator(6, 20, 7, columns(r))
/
