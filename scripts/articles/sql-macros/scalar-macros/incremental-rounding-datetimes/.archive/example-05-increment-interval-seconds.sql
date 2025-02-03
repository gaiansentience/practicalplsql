with 
    
    function increment_seconds_interval(
        p_interval in dsinterval_unconstrained
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            p_interval 
            - numtodsinterval(extract(second from p_interval), 'second')
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    extract(second from p_interval)/p_increment
                    ) 
                when -1 then
                floor(
                    extract(second from p_interval)/p_increment
                    ) 
                else
                round(
                    extract(second from p_interval)/p_increment
                    ) 
                end                    
                * p_increment
                , 'second')
        ]';
    end increment_seconds_interval;    
    
base as (
    select numtodsinterval(level/1000, 'second') + numtodsinterval(level, 'second') as interval_value
    from dual
    connect by level <= 600
)
select 
    interval_value
    , increment_seconds_interval(interval_value, 5) as to_5_seconds
    , increment_seconds_interval(interval_value, 10) as to_10_seconds
    , increment_seconds_interval(interval_value, 15) as to_15_seconds
    , increment_seconds_interval(interval_value, 1/100) as to_30_seconds
from base
--where mod(extract(second from cast(interval_value as timestamp)),7) = 0
/
