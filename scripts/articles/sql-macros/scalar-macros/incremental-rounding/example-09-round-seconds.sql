with 
    function round_up_seconds(
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
    end round_up_seconds;
    
base as (
    select sysdate + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , round_up_seconds(dt, 5) as round_5_seconds
    , round_up_seconds(dt, 10) as round_10_seconds
    , round_up_seconds(dt, 15) as round_15_seconds
    , round_up_seconds(dt, 30) as round_30_seconds
from base
where mod(extract(second from cast(dt as timestamp)),7) = 0
/
