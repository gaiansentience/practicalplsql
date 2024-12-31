set pagesize 25
column n format 0.9
column round_n_to_half format 0.9

with 
    function row_generator(
        p_rows in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator;
    
    function round_increments(
        n in number
        , p_increment in number
        , scale in number default 0
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return 'round(n/p_increment, scale) * p_increment';
    end round_increments;

select 
    r.n
    , round_increments(r.n, 5, 1) round_n_to_half
    , r.m
    , round_increments(r.m, 5) as round_m_to_5
from 
    (
    select n/10 as n, n as m
    from row_generator(20)
    ) r
/
