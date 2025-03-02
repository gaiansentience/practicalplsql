--4.1-trunc-increments-function.sql

create or replace function trunc_increments(
    p_value in number
    , p_increment in number
) return number
is
    pragma udf;
begin
    return trunc( p_value/p_increment ) * p_increment;
end trunc_increments;
/
