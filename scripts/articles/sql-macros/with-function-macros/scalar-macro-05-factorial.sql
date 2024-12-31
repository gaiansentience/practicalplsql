--scalar-macro-05-factorial.sql

column n format 99
column expanded format a40

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
    
    function factorial_expansion(
        p_n in integer
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'~
            select 
                listagg(n, ' x ') within group (order by n desc) 
            from row_generator(p_n, columns(n))
            ~';
    end factorial_expansion;   
    
    function factorial_expression(p_n in integer)
    return varchar2 sql_macro(scalar)
    is
    begin
        return q'~
            p_n || '! = ' || factorial_expansion(p_n) || ' = ' || factorial(p_n)
        ~';
    end factorial_expression;

    function factorial_generator(
        p_max_n in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                n as "n"
                , factorial(n) as "n!"
                , factorial_expression(n) as "expanded"
            from row_generator(p_max_n, columns(n))
            ~';
    end factorial_generator;

select * from factorial_generator(7)
/

/*
  n         n! expanded                                
--- ---------- ----------------------------------------
  1          1 1! = 1 = 1                              
  2          2 2! = 2 x 1 = 2                          
  3          6 3! = 3 x 2 x 1 = 6                      
  4         24 4! = 4 x 3 x 2 x 1 = 24                 
  5        120 5! = 5 x 4 x 3 x 2 x 1 = 120            
  6        720 6! = 6 x 5 x 4 x 3 x 2 x 1 = 720        
  7       5040 7! = 7 x 6 x 5 x 4 x 3 x 2 x 1 = 5040   
*/