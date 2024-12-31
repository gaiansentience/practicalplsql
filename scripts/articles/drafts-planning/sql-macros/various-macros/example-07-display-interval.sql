column format_interval format a40
column format_half_interval format a40
column format_tenth_interval format a40

with 
    function display_interval(
        p_interval in dsinterval_unconstrained
        , p_seconds_precision in number default 2
    )return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
        trim(
            case when extract(day from p_interval) > 0 then 
                extract(day from p_interval) || ' days '
            end 
            || case when extract(hour from p_interval) > 0 then
                extract(hour from p_interval) || ' hours '
            end
            || case when extract(minute from p_interval) > 0 then 
                extract(minute from p_interval)  || ' minutes '
            end
            || case when extract(second from p_interval) > 0 then 
                round(
                    extract(second from p_interval)
                    , p_seconds_precision)
                || ' seconds'
            end
            )
            ]';
    end display_interval;

base (interval_value) as (
    select numtodsinterval(dbms_random.value(0, 1) * 100000, 'second')
    from dual
    connect by level <= 5
)
select 
    interval_value
    , display_interval(interval_value) as format_interval
    , display_interval(interval_value/2) as format_half_interval
    , display_interval(interval_value/10) as format_tenth_interval
from base
/