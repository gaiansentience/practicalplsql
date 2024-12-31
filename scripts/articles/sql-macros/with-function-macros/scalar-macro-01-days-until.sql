--scalar-macro-01-days-until.sql

with 
    function days_until(p_holiday_mm_dd in varchar2
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
        case sign(trunc(sysdate) - to_date(p_holiday_mm_dd, 'mm-dd')) 
            when 1 then add_months(to_date(p_holiday_mm_dd, 'mm-dd'), 12) 
            else to_date(p_holiday_mm_dd,'mm-dd') 
        end 
        - trunc(sysdate)
        ]';
    end days_until;

holidays(mm_dd, holiday_name) as (
    select '12-31', 'new year''s eve' from dual union all
    select '10-31', 'halloween' from dual union all
    select '12-25', 'christmas' from dual union all
    select '02-14', 'valentine''s' from dual 
)

select 
    holiday_name as "holiday"
    , days_until(mm_dd) as "days to wait"
    , days_until(mm_dd) + trunc(sysdate) as "waiting ends"
from holidays
order by "days to wait"
/

/*
holiday        days to wait waiting ends     
-------------- ------------ -----------------
new year's eve            0 December 31, 2024
valentine's              45 February 14, 2025
halloween               304 October 31, 2025 
christmas               359 December 25, 2025
*/