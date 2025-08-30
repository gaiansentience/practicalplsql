--3.1-floor-increments-function.sql

create or replace function floor_increments(
    p_value in number
    , p_increment in number
) return number
is
    pragma udf;
begin
    return floor( p_value/p_increment ) * p_increment;
end floor_increments;
/
