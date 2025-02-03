--5.2-round-from-zero-increments-macro.sql
    
with
function incremental_round_from_zero(
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
end incremental_round_from_zero;

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
    , incremental_round_from_zero(val, inc) as round_from_zero_by_inc
from base
/

/*
       VAL        INC ROUND_FROM_ZERO_BY_INC
---------- ---------- ----------------------
        13          5                     15
     1.217        .25                   1.25
        17         12                     24
  1.172839       .125                   1.25
       -13          5                    -15
    -1.217        .25                  -1.25
       -17         12                    -24
 -1.172839       .125                  -1.25
*/
