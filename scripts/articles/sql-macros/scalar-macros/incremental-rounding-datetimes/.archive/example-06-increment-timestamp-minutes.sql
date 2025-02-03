with 
    
    function increment_minutes_timestamp(
        p_timestamp in timestamp
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            p_timestamp 
            - numtodsinterval(extract(minute from p_timestamp), 'minute')
            - numtodsinterval(extract(second from p_timestamp), 'second')
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    ((extract(minute from p_timestamp) * 60) + extract(second from p_timestamp))
                    /(p_increment * 60)
                    ) 
                when -1 then
                floor(
                    ((extract(minute from p_timestamp) * 60) + extract(second from p_timestamp))
                    /(p_increment * 60)
                    ) 
                else
                round(
                    ((extract(minute from p_timestamp) * 60) + extract(second from p_timestamp))
                    /(p_increment * 60)
                    ) 
                end                    
                * (p_increment * 60)
                , 'second')
        ]';
    end increment_minutes_timestamp;    
    
base as (
    select localtimestamp + numtodsinterval(level,'minute') + numtodsinterval(level + level/1000, 'second') as dt
    from dual
    connect by level <= 600
)
select 
    dt
    , increment_minutes_timestamp(dt, 5) as to_5_minutes
    , increment_minutes_timestamp(dt, 10) as to_10_minutes
    , increment_minutes_timestamp(dt, 15) as to_15_minutes
    , increment_minutes_timestamp(dt, 90/60) as to_half_minutes
from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/

