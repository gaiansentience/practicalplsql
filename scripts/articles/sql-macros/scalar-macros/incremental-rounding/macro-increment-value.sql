set pagesize 25
   
create or replace function m_increment_value(
    n in number
    , p_increment in number
    , p_mode in number default 1
) return varchar2 sql_macro(scalar)
is
begin
    return '
        case p_mode 
            when 1 then ceil(n/p_increment) 
            when -1 then floor(n/p_increment) 
            else round(n/p_increment) 
        end * p_increment
        ';
end m_increment_value;
/

--test the function
select 
    r.n
    , m_increment_value(r.n, 1/2, 0) "floor n by 1/2"
    , m_increment_value(r.n, 1/4, 0) "round n by 1/4"
    , m_increment_value(r.n, 1/8, 1) "ceil n by 1/8"
    , r.m
    , m_increment_value(r.m, 5, 0) as "round m by 5"
    , m_increment_value(r.m, 12, 1) as "ceil m by 12"
    , r.p
    , m_increment_value(r.p, 1/20, 1) "ceil n by 1/20"
    , r.o
    , m_increment_value(r.o, 42, -1) "floor o by 42"
from 
    (
    select n/10 as n, n as m, n * (n + 2) as o, n * (n + 2)/1000 as p
    from row_generator(20, columns(n))
    ) r
/
