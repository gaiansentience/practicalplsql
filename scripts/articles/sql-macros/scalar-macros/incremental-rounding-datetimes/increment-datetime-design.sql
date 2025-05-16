with 
    
    function increment_datetime(
        p_value in date
        , p_increment in number
        , p_unit in varchar2 default 'second'
        , p_mode in varchar2 default 'round'
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_value) 
            + numtodsinterval(
                case p_mode
                when 'ceil' then
                ceil(
                    (p_value - trunc(p_value) ) * 24 * 60 * 60 
                    / (p_increment * case p_unit when 'second' then 1 when 'minute' then 60 when 'hour' then 60 * 60 end)
                    ) 
                when 'floor' then
                floor(
                    (p_value - trunc(p_value) ) * 24 * 60 * 60 
                    / (p_increment * case p_unit when 'second' then 1 when 'minute' then 60 when 'hour' then 60 * 60 end)
                    ) 
                else
                round(
                    (p_value - trunc(p_value) ) * 24 * 60 * 60 
                    / (p_increment * case p_unit when 'second' then 1 when 'minute' then 60 when 'hour' then 60 * 60 end)
                    ) 
                end                    
                    * (p_increment * case p_unit when 'second' then 1 when 'minute' then 60 when 'hour' then 60 * 60 end)
                , 'second')
        ]';
    end increment_datetime;    
    
base as (
    select sysdate + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , increment_datetime(dt, 5) as to_5_seconds
    , increment_datetime(dt, 10) as to_10_seconds
    , increment_datetime(dt, 15) as to_15_seconds
    , increment_datetime(dt, 90) as to_90_seconds
from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/
