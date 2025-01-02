with 
    function seconds_to_increment(
        p_timestamp in timestamp
        , p_increment in number
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_timestamp, 'mi') 
            + numtodsinterval(
                ceil(
                    (p_timestamp - trunc(p_timestamp, 'mi') ) * 24 * 60 * 60/p_increment
                    ) * p_increment
                , 'second')
        ]';
    end seconds_to_increment;
    
    function increment_seconds(
        p_timestamp in timestamp
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            p_timestamp 
            - extract(second from p_timestamp)
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    extract(second from p_timestamp)/p_increment
                    ) 
                when -1 then
                floor(
                    extract(second from p_timestamp)/p_increment
                    ) 
                else
                round(
                    extract(second from p_timestamp)/p_increment
                    ) 
                end                    
                * p_increment
                , 'second')
        ]';
    end increment_seconds;    
    
base as (
    select localtimestamp + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , increment_seconds(dt, 5) as to_5_seconds
    , increment_seconds(dt, 10) as to_10_seconds
    , increment_seconds(dt, 15) as to_15_seconds
    , increment_seconds(dt, 90) as to_30_seconds
from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/


select systimestamp, localtimestamp at time zone '0:00', current_timestamp, extract(timezone_region from current_timestamp)
from dual
/