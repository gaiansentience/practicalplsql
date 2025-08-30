--macro-row-generator.sql

create or replace function row_generator(
    p_rows in number
    , p_alias in dbms_tf.columns_t default null
) return varchar2 sql_macro(table)
is
    l_sql varchar2(1000);
    l_value_alias varchar2(128);
begin
    l_sql := '
        select level as ##VALUE_ALIAS##
        from dual 
        connect by level <= p_rows
        ';  
    l_value_alias := case when p_alias is null then 'n' else p_alias(1) end;
    l_sql := replace(l_sql, '##VALUE_ALIAS##', l_value_alias);
    return l_sql;
end row_generator;
/

--test the macro
select *
from row_generator(5, columns(x))
/
select *
from row_generator(5)
/