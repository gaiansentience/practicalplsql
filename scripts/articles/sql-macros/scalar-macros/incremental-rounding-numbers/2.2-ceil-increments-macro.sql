--2.2-ceil-increments-macro.sql

create or replace function ceil_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'ceil( p_value/p_increment ) * p_increment';
end ceil_increments_sqm;
/
