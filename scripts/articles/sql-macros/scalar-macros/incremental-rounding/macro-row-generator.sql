

create or replace function row_generator(
    p_rows in number
    , p_alias in dbms_tf.columns_t default null
) return varchar2 sql_macro(table)
is
    l_sql varchar2(1000);
begin
    l_sql := '
        select level as ##alias##
        from dual 
        connect by level <= p_rows
        ';    
    l_sql := replace(l_sql, '##alias##', case when p_alias is null then 'n' else p_alias(1) end);
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