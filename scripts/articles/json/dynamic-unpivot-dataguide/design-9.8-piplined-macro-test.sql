prompt design-9.8-pipelined-macro-test.sql


column Year format 9999
column Report format a25
column Volume format 999999

set pagesize 100

prompt validate sales data pivots with macro

select "Report", "Year", sum("Volume") as "Volume"
from
    (
    select 'Quarterly Sales' as "Report", "Year", "Volume"
    from unpivot_results(quarterly_sales_v, columns("Year", "Quarter", "Volume"))
    union all
    select 'Regional Sales' as "Report", "Year", "Volume"
    from unpivot_results(regional_sales_v, columns("Year", "Region", "Volume"))
    union all
    select 'Regional Quarterly Sales' as "Report", "Year", "Volume"
    from unpivot_results(regional_quarterly_sales_v, columns("Year", "RegionQuarter", "Volume"))
    union all
    select 'Monthly Sales' as "Report", "Year", "Volume"
    from unpivot_results(monthly_sales_v, columns("Year", "Month", "Volume"))
    union all
    select 'Regional Monthly Sales' as "Report", "Year", "Volume"
    from unpivot_results(regional_monthly_sales_v, columns("Year", "RegionMonth", "Volume"))
    union all
    select 'Annual Sales' as "Report", "Year", "Volume"
    from annual_sales_v
    )
group by "Report", "Year"
order by "Year", "Report"
/

/*
Report                     Year  Volume
------------------------- ----- -------
Annual Sales               2021  696321
Monthly Sales              2021  696321
Quarterly Sales            2021  696321
Regional Monthly Sales     2021  696321
Regional Quarterly Sales   2021  696321
Regional Sales             2021  696321
Annual Sales               2022  626526
Monthly Sales              2022  626526
Quarterly Sales            2022  626526
Regional Monthly Sales     2022  626526
Regional Quarterly Sales   2022  626526
Regional Sales             2022  626526
Annual Sales               2023  649650
Monthly Sales              2023  649650
Quarterly Sales            2023  649650
Regional Monthly Sales     2023  649650
Regional Quarterly Sales   2023  649650
Regional Sales             2023  649650

18 rows selected. 
*/