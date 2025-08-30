--1.2-round-increments-macro.sql

create or replace function round_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'round( p_value/p_increment ) * p_increment';
end round_increments_sqm;
/
