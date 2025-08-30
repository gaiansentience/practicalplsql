--7.1-increments-function.sql

create or replace function to_increments(
    p_value in number
    , p_increment in number
    , p_mode in varchar2 default 'round'
) return number
is
    pragma udf;
begin
    return 
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
        end;
end to_increments;
/
