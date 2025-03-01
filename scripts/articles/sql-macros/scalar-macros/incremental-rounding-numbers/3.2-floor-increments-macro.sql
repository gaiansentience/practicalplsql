--3.2-floor-increments-macro.sql
    
create or replace function floor_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'floor( p_value/p_increment ) * p_increment';
end floor_increments_sqm;
/

with base(n, i) as (
    values 
        (1.217, 1/4), (1.08, 1/4)
        , (13, 5), (11, 5)
        , (19, 12), (14, 12)
)
select 
    n as "number"
    , i as "increment"
    , floor_increments_sqm(n, i) as "result"
from base
order by i, n
/

/*
    number  increment     result
---------- ---------- ----------
      1.08        .25          1
     1.217        .25          1
        11          5         10
        13          5         10
        14         12         12
        19         12         12
*/