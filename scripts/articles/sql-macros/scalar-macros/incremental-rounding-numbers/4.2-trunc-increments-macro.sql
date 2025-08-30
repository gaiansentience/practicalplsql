--4.2-trunc-increments-macro.sql

create or replace function trunc_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'trunc( p_value/p_increment ) * p_increment';
end trunc_increments_sqm;
/
