with 
    
    function increment_seconds_timestamp(
        p_timestamp in timestamp
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            p_timestamp 
            - numtodsinterval(extract(hour from p_timestamp), 'hour')
            - numtodsinterval(extract(minute from p_timestamp), 'minute')
            - numtodsinterval(extract(second from p_timestamp), 'second')
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    ( (extract(hour from p_timestamp) * 60 * 60) + (extract(minute from p_timestamp) * 60) + extract(second from p_timestamp) )
                    /p_increment
                    ) 
                when -1 then
                floor(
                    ( (extract(hour from p_timestamp) * 60 * 60) + (extract(minute from p_timestamp) * 60) + extract(second from p_timestamp) )
                    /p_increment
                    ) 
                else
                round(
                    ( (extract(hour from p_timestamp) * 60 * 60) + (extract(minute from p_timestamp) * 60) + extract(second from p_timestamp) )
                    /p_increment
                    ) 
                end                    
                * p_increment
                , 'second')
        ]';
    end increment_seconds_timestamp;    
    
base as (
    select localtimestamp + numtodsinterval(level/100, 'second') as dt
    from dual
    connect by level <= 600
)
select 
    dt
    , increment_seconds_timestamp(dt, 5) as to_5_seconds
    , increment_seconds_timestamp(dt, 10) as to_10_seconds
    , increment_seconds_timestamp(dt, 15) as to_15_seconds
    , increment_seconds_timestamp(dt, 1/1000) as to_30_seconds
from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/


select ceil(interval '3:35.34' minute to second / 15/60, 'MI')*15/60