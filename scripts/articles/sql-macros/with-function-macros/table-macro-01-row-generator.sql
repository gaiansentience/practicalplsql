--table-macro-01-row-generator.sql

column n format 9

with
    function row_generator(
        p_rows in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return q'[
            select level as n 
            from dual 
            connect by level <= p_rows
            ]';
    end row_generator;

select b.n
from row_generator(4) b
/

/*
N
-
1
2
3
4
*/