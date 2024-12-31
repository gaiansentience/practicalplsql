with 
    function seconds_to_increment(
        p_date in date
        , p_increment in number
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'mi') 
            + numtodsinterval(
                ceil(
                    (p_date - trunc(p_date, 'mi') ) * 24 * 60 * 60/p_increment
                    ) * p_increment
                , 'second')
        ]';
    end seconds_to_increment;
    
base as (
    select sysdate + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , seconds_to_increment(dt, 5) as to_5_seconds
    , seconds_to_increment(dt, 10) as to_10_seconds
    , seconds_to_increment(dt, 15) as to_15_seconds
    , seconds_to_increment(dt, 30) as to_30_seconds
from base
where mod(extract(second from cast(dt as timestamp)),7) = 0
/
