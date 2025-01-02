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

select n 
from row_generator(4, columns(n))
/
