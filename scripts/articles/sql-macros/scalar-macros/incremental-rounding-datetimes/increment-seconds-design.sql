with 
    
    function increment_seconds(
        p_date in date
        , p_increment in number
        , p_mode in number default 1
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'hh') 
            + numtodsinterval(
                case p_mode
                when 1 then
                ceil(
                    (p_date - trunc(p_date, 'hh') ) * 24 * 60 * 60/p_increment
                    ) 
                when -1 then
                floor(
                    (p_date - trunc(p_date, 'hh') ) * 24 * 60 * 60/p_increment
                    ) 
                else
                round(
                    (p_date - trunc(p_date, 'hh') ) * 24 * 60 * 60/p_increment
                    ) 
                end                    
                    * p_increment
                , 'second')
        ]';
    end increment_seconds;    
    
base as (
    select sysdate + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , increment_seconds(dt, 5) as to_5_seconds
    , increment_seconds(dt, 10) as to_10_seconds
    , increment_seconds(dt, 15) as to_15_seconds
    , increment_seconds(dt, 90) as to_90_seconds
from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/
