--4.2-trunc-increments-macro.sql
    
with
function incremental_trunc(
    p_value in number
    , p_increment in number
) return varchar2
sql_macro(scalar)
is
begin
    return 'trunc(p_value/p_increment) * p_increment';
end incremental_trunc;

base(val, inc) as (
    select 13, 5 from dual union all
    select 1.217, 1/4 from dual union all
    select 17, 12 from dual union all
    select 1.172839, 1/8 from dual union all
    select -13, 5 from dual union all
    select -1.217, 1/4 from dual union all
    select -17, 12 from dual union all
    select -1.172839, 1/8 from dual 
)
select 
    val
    , inc
    , incremental_trunc(val, inc) as trunc_by_inc
from base
/

/*
       VAL        INC TRUNC_BY_INC
---------- ---------- ------------
        13          5           10
     1.217        .25            1
        17         12           12
  1.172839       .125        1.125
       -13          5          -10
    -1.217        .25           -1
       -17         12          -12
 -1.172839       .125       -1.125
*/
