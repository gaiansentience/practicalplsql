prompt sales_data-regional_quarterly.sql
prompt run sales_data.report_sources.sql to create pivoted data sources

spool .\sales_data-regional-quarterly.txt
prompt sales_data-regional-quarterly.txt

set feedback on
set pagesize 1000

column Year format 99999
column RegionQuarter format a12
column Volume format 999999

column EastQtr1 format 999999
column WestQtr1 format 999999
column NorthQtr1 format 999999
column SouthQtr1 format 999999
column CentralQtr1 format 999999

column EastQtr2 format 999999
column WestQtr2 format 999999
column NorthQtr2 format 999999
column SouthQtr2 format 999999
column CentralQtr2 format 999999

column EastQtr3 format 999999
column WestQtr3 format 999999
column NorthQtr3 format 999999
column SouthQtr3 format 999999
column CentralQtr3 format 999999

column EastQtr4 format 999999
column WestQtr4 format 999999
column NorthQtr4 format 999999
column SouthQtr4 format 999999
column CentralQtr4 format 999999

prompt Annual Sales
select "Year", "Volume"
from annual_sales_v
order by "Volume";

prompt Regional Quarterly Sales
prompt East region quarterly sales
select 
    "Year", "EastQtr1", "EastQtr2", "EastQtr3", "EastQtr4"
from regional_quarterly_sales_v
order by "Year";

prompt West region quarterly sales
select 
    "Year", "WestQtr1", "WestQtr2", "WestQtr3", "WestQtr4"
from regional_quarterly_sales_v
order by "Year";

prompt North region quarterly sales
select 
    "Year", "NorthQtr1", "NorthQtr2", "NorthQtr3", "NorthQtr4"
from regional_quarterly_sales_v
order by "Year";

prompt South region quarterly sales
select 
    "Year", "SouthQtr1", "SouthQtr2", "SouthQtr3", "SouthQtr4"
from regional_quarterly_sales_v
order by "Year";

prompt Central region quarterly sales
select 
    "Year", "CentralQtr1", "CentralQtr2", "CentralQtr3", "CentralQtr4"    
from regional_quarterly_sales_v
order by "Year";

prompt Add each regional quarterly column to validate yearly totals
select 
    "Year", 
    (
        "EastQtr1" + "WestQtr1" + "NorthQtr1" + "SouthQtr1" + "CentralQtr1"
        + "EastQtr2" + "WestQtr2" + "NorthQtr2" + "SouthQtr2" + "CentralQtr2"
        + "EastQtr3" + "WestQtr3" + "NorthQtr3" + "SouthQtr3" + "CentralQtr3"
        + "EastQtr4" + "WestQtr4" + "NorthQtr4" + "SouthQtr4" + "CentralQtr4"
    ) as "Volume"    
from regional_quarterly_sales_v
order by "Year";

prompt Unpivot Regional Quarterly Sales
select "Year", "Volume", "RegionQuarter"
from
    regional_quarterly_sales_v
    unpivot (
        "Volume" for "RegionQuarter" in (
            "EastQtr1", "WestQtr1", "NorthQtr1", "SouthQtr1", "CentralQtr1",
            "EastQtr2", "WestQtr2", "NorthQtr2", "SouthQtr2", "CentralQtr2",
            "EastQtr3", "WestQtr3", "NorthQtr3", "SouthQtr3", "CentralQtr3",
            "EastQtr4", "WestQtr4", "NorthQtr4", "SouthQtr4", "CentralQtr4"    
            )
    );

prompt Unpivot each regional quarterly column to validate yearly totals
with unpivoted_sales as (
    select "Year", "Volume", "RegionQuarter"
    from
        regional_quarterly_sales_v
        unpivot (
            "Volume" for "RegionQuarter" in (
                "EastQtr1", "WestQtr1", "NorthQtr1", "SouthQtr1", "CentralQtr1",
                "EastQtr2", "WestQtr2", "NorthQtr2", "SouthQtr2", "CentralQtr2",
                "EastQtr3", "WestQtr3", "NorthQtr3", "SouthQtr3", "CentralQtr3",
                "EastQtr4", "WestQtr4", "NorthQtr4", "SouthQtr4", "CentralQtr4"    
                )
        )
)
select 
    "Year", 
    sum("Volume") as "Volume"
from unpivoted_sales
group by "Year"
order by "Year";

spool off