--5.2-round-from-zero-increments-macro.sql

create or replace function round_from_zero_increments_sqm(
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
end round_from_zero_increments_sqm;
/
