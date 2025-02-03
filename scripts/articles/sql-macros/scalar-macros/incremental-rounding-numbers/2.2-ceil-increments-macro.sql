--2.2-ceil-increments-macro.sql
    
with
function incremental_ceil(
    p_value in number
    , p_increment in number
) return varchar2
sql_macro(scalar)
is
begin
    return 'ceil(p_value/p_increment) * p_increment';
end incremental_ceil;

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
    , incremental_ceil(val, inc) as ceil_by_inc
from base
/

/*
       VAL        INC CEIL_BY_INC
---------- ---------- -----------
        13          5          15
     1.217        .25        1.25
        17         12          24
  1.172839       .125        1.25
       -13          5         -10
    -1.217        .25          -1
       -17         12         -12
 -1.172839       .125      -1.125
*/