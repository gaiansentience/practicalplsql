--table-macro-04-factorial-generator.sql

column expression format a30
column n format 99

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

    function factorial_generator(
        p_max_n in number
    ) return varchar2 sql_macro(table)
    is
    begin

        return q'~
            select 
                a.n as "n"
                , round(exp(sum(ln(b.m)))) as "n!"
                , a.n || '! = ' 
                    || listagg(b.m, ' x ') within group (order by b.m desc) 
                    || ' = ' || round(exp(sum(ln(b.m)))) as "expression"
            from
                (
                select n
                from row_generator(p_max_n, columns(n))
                ) a
                cross apply
                (
                select m 
                from row_generator(a.n, columns(m))
                ) b
            group by a.n
        ~';
        
    end factorial_generator;

select *
from factorial_generator(4)
/

/*
  n         n! expression                    
--- ---------- ------------------------------
  1          1 1! = 1 = 1                    
  2          2 2! = 2 x 1 = 2                
  3          6 3! = 3 x 2 x 1 = 6            
  4         24 4! = 4 x 3 x 2 x 1 = 24    
*/