with 

    function minutes_to_increment(
        p_date in date
        , p_increment in number
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'hh') 
            + numtodsinterval(
                ceil(
                    (p_date - trunc(p_date, 'hh') ) * (24 * 60)/p_increment
                    ) * p_increment
                , 'minute')
        ]';
    end minutes_to_increment;

base(dt) as (
    select sysdate + numtodsinterval(level - 1, 'minute')
    from dual connect by level <= 61
)
select 
    dt
    , minutes_to_increment(dt, 5) as to_5_minutes
    , minutes_to_increment(dt, 15) as to_15_minutes
    , minutes_to_increment(dt, 30) as to_30_minutes
from base
where mod(extract(minute from cast(dt as timestamp)),3) = 0
/
