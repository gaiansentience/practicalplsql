--2.2-ceil-increments-macro.sql

create or replace function ceil_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'ceil( p_value/p_increment ) * p_increment';
end ceil_increments_sqm;
/
    
with base(n, i) as (
    values 
        (1.217, 1/4), (1.08, 1/4)
        , (13, 5), (11, 5)
)
select 
    n as "number"
    , i as "increment"
    , ceil_increments_sqm(n, i) as "result"
from base
order by i, n
/

/*
    number  increment     result
---------- ---------- ----------
      1.08        .25       1.25
     1.217        .25       1.25
        11          5         15
        13          5         15
*/