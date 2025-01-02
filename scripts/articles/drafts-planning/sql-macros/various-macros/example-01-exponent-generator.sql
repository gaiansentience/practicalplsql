column equation format a12

with
    function row_generator(
        p_rows in number
        , p_alias in dbms_tf.columns_t
    ) return varchar2 sql_macro(table)
    is
        l_sql varchar2(1000);
    begin
        l_sql := q'[
            select level as ##alias## 
            from dual 
            connect by level <= p_rows
            ]';
        l_sql := replace(l_sql, '##alias##', p_alias(1));
        return l_sql;
    end row_generator;

    function exponent_generator(
        p_base in number
        , p_max_power in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                p_base as "base"
                , n - 1 as "exponent"
                , power(p_base, n - 1) as "result"
                , p_base || '^' || (n - 1) || ' = ' || power(p_base, n - 1) as "equation"
            from row_generator(p_max_power + 1, columns(n))
        ~';
    end exponent_generator;

select *
from exponent_generator(2, 8)
/
