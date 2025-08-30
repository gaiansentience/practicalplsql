--2.1-ceil-increments-function.sql

create or replace function ceil_increments(
    p_value in number
    , p_increment in number
) return number
is
    pragma udf;
begin
    return ceil( p_value/p_increment ) * p_increment;
end ceil_increments;
/
