--7.2-increments-macro.sql

create or replace function to_increments_sqm(
    p_value in number
    , p_increment in number
    , p_mode in varchar2 default 'round'
) return varchar2 sql_macro(scalar)
is
begin
    return 
    q'!
        case p_mode
            when 'round' then
                round(p_value/p_increment) * p_increment
            when 'ceil' then
                ceil(p_value/p_increment) * p_increment
            when 'floor' then
                floor(p_value/p_increment) * p_increment
            when 'trunc' then
                trunc(p_value/p_increment) * p_increment
            else
                case sign(p_value) 
                    when -1 then floor(p_value/p_increment) 
                    else ceil(p_value/p_increment) 
                end * p_increment
        end
    !';
end to_increments_sqm;
/
