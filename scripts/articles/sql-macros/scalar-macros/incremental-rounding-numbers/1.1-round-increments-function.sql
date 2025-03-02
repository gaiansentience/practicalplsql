--1.1-round-increments-function.sql

create or replace function round_increments(
    p_value in number
    , p_increment in number
) return number
is
    pragma udf;
begin
    return round( p_value/p_increment ) * p_increment;
end round_increments;
/
