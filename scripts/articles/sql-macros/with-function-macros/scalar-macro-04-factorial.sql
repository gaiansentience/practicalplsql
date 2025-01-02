--scalar-macro-04-factorial.sql

column x format 9

with
    function row_generator(
        p_rows in number
        , p_alias in dbms_tf.columns_t
    ) return varchar2 sql_macro(table)
    is
        l_sql varchar2(1000);
    begin
        l_sql := q'~
            select level as ##alias##
            from dual
            connect by level <= p_rows
        ~';
        l_sql := replace(l_sql, '##alias##', p_alias(1));
        return l_sql;
    end row_generator;
    
    function factorial(
        p_n in integer
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'~
            select 
                round(exp(sum(ln(n)))) as "n!"
            from row_generator(p_n, columns(n))
            ~';
    end factorial;
    
select 
    x as "x"
    , factorial(x) as "x!"
from row_generator(5,columns(x))
/

/*
x         x!
- ----------
1          1
2          2
3          6
4         24
5        120
*/