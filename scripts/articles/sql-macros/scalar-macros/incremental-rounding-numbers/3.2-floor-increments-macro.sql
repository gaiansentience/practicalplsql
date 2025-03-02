--3.2-floor-increments-macro.sql
    
create or replace function floor_increments_sqm(
    p_value in number
    , p_increment in number
) return varchar2 sql_macro(scalar)
is
begin
    return 'floor( p_value/p_increment ) * p_increment';
end floor_increments_sqm;
/
