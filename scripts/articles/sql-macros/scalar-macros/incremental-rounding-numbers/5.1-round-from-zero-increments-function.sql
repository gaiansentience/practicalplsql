--5.1-round-from-zero-increments-function.sql

create or replace function round_from_zero_increments(
    p_value in number
    , p_increment in number
) return number
is
    pragma udf;
begin
    return 
        case sign(p_value) 
            when -1 then floor(p_value/p_increment) 
            else ceil(p_value/p_increment) 
        end * p_increment;
end round_from_zero_increments;
/
