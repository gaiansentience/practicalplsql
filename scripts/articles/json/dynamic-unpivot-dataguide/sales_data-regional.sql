prompt sales_data-regional.sql
prompt run sales_data.report_sources.sql to create pivoted data sources

spool .\sales_data-regional.txt
prompt sales_data-regional.txt

set feedback on
set pagesize 1000

column Year format 99999
column Region format a9
column Volume format 999999

column East format 999999
column West format 999999
column North format 999999
column South format 999999
column Central format 999999

prompt Annual Sales
select "Year", "Volume"
from annual_sales_v
order by "Volume";

prompt Regional Sales
select 
    "Year", "East", "West", "North", "South", "Central"
from regional_sales_v
order by "Year";

prompt Add each regional column to validate yearly totals
select 
    "Year", 
    (
        "East" + "West" + "North" + "South" + "Central"
    ) as "Volume"
from regional_sales_v
order by "Year";

prompt Unpivot Regional Sales
select "Year", "Region", "Volume"
from 
    regional_sales_v
    unpivot (
        "Volume" for "Region" in (
            "East", "West", "North", "South", "Central")
    );

prompt Unpivot each regional column to validate yearly totals
with unpivot_sales as (
    select "Year", "Region", "Volume"
    from 
        regional_sales_v
        unpivot (
            "Volume" for "Region" in (
                "East", "West", "North", "South", "Central")
        )
)
select 
    "Year", 
    sum("Volume") as "Volume"
from unpivot_sales
group by "Year"
order by "Year";

spool off