--scalar-macro-02-display-interval.sql

column format_interval format a30
column format_half_interval format a30
column format_tenth_interval format a30

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
                extract(hour from p_interval) || ' hr '
            end
            || case when extract(minute from p_interval) > 0 then 
                extract(minute from p_interval)  || ' min '
            end
            || case when extract(second from p_interval) > 0 then 
                round(
                    extract(second from p_interval)
                    , p_seconds_precision)
                || ' sec'
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
    display_interval(interval_value) as format_interval
    , display_interval(interval_value/2) as format_half_interval
    , display_interval(interval_value/10) as format_tenth_interval
from base
/

/*
FORMAT_INTERVAL                FORMAT_HALF_INTERVAL           FORMAT_TENTH_INTERVAL         
------------------------------ ------------------------------ ------------------------------
1 hr 41 min 45.03 sec          50 min 52.51 sec               10 min 10.5 sec               
8 hr 12 min 21.37 sec          4 hr 6 min 10.68 sec           49 min 14.14 sec              
9 hr 22 min 36.37 sec          4 hr 41 min 18.19 sec          56 min 15.64 sec              
17 hr 55 min 31.82 sec         8 hr 57 min 45.91 sec          1 hr 47 min 33.18 sec         
1 days 1 hr 12 min 42.27 sec   12 hr 36 min 21.13 sec         2 hr 31 min 16.23 sec            
*/