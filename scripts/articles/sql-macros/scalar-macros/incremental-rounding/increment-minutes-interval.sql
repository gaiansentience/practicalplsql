with 
    
    function increment_minutes_interval(
        p_interval in dsinterval_unconstrained
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            p_interval 
            - numtodsinterval(extract(minute from p_interval), 'minute')
            - numtodsinterval(extract(second from p_interval), 'second')
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    ((extract(minute from p_interval) * 60) + extract(second from p_interval))
                    /(p_increment * 60)
                    ) 
                when -1 then
                floor(
                    ((extract(minute from p_interval) * 60) + extract(second from p_interval))
                    /(p_increment * 60)
                    ) 
                else
                round(
                    ((extract(minute from p_interval) * 60) + extract(second from p_interval))
                    /(p_increment * 60)
                    ) 
                end                    
                * (p_increment * 60)
                , 'second')
        ]';
    end increment_minutes_interval;    
    
base as (
    select numtodsinterval(level,'minute') + numtodsinterval(level + level/100, 'second') as interval_value
    from dual
    connect by level <= 600
)
select 
    interval_value
    , increment_minutes_interval(interval_value, 5) as to_5_minutes
    , increment_minutes_interval(interval_value, 10) as to_10_minutes
    , increment_minutes_interval(interval_value, 15) as to_15_minutes
    , increment_minutes_interval(interval_value, 5/60) as to_half_minutes
from base
--where mod(extract(second from cast(interval_value as timestamp)),7) = 0
/

