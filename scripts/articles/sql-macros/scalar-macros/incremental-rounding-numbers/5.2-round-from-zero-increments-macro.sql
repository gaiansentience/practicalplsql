--5.2-round-from-zero-increments-macro.sql

create or replace function incremental_round_from_zero_sqm(
    p_value in number
    , p_increment in number
) return varchar2
sql_macro(scalar)
is
begin
    return 
        'case sign(p_value) 
            when -1 then floor(p_value/p_increment)
            else ceil(p_value/p_increment) 
        end * p_increment';
end incremental_round_from_zero_sqm;
/

with base(n, i) as (
    values 
        (-1.172839, 1/8), (1.172839, 1/8)
        , (-1.217, 1/4), (1.217, 1/4)
        , (-13, 5), (13, 5)
        , (-17, 12), (17, 12)
)
select 
    n as "number"
    , i as "increment"
    , incremental_round_from_zero_sqm(n, i) as "result"
from base
order by i, n
/

/*
    number  increment     result
---------- ---------- ----------
 -1.172839       .125      -1.25
  1.172839       .125       1.25
    -1.217        .25      -1.25
     1.217        .25       1.25
       -13          5        -15
        13          5         15
       -17         12        -24
        17         12         24
*/
