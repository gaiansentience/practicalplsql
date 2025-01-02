with 

    function increment_minutes(
        p_date in date
        , p_increment in number
        , p_mode in number default 0
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'hh') 
            + numtodsinterval(
                case p_mode 
                when 1 then
                    ceil(
                        (p_date - trunc(p_date, 'hh') ) * (24 * 60 * 60)/(p_increment * 60)
                        ) 
                when -1 then
                    floor(
                        (p_date - trunc(p_date, 'hh') ) * (24 * 60 * 60)/(p_increment * 60)
                        )                 
                else
                    round(
                        (p_date - trunc(p_date, 'hh') ) * (24 * 60 * 60)/(p_increment * 60)
                        ) 
                end
                    * (p_increment * 60)
                , 'second')
        ]';
    end increment_minutes;    

base(dt) as (
    select sysdate + numtodsinterval(level - 1, 'minute') + numtodsinterval(level - 1, 'second')
    from dual connect by level <= 61
)
select 
    dt
    , increment_minutes(dt, 5) as to_5_minutes
    , increment_minutes(dt, 15) as to_15_minutes
    , increment_minutes(dt, 30) as to_30_minutes
    ,increment_minutes(dt,15/60, 1) by_5
from base
--where mod(extract(minute from cast(dt as timestamp)),3) = 0
/
