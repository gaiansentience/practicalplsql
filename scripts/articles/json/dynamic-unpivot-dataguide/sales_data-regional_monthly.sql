prompt sales_data-regional_monthly.sql
prompt run sales_data.report_sources.sql to create pivoted data sources

spool .\sales_data-regional-monthly.txt
prompt .\sales_data-regional-monthly.txt

set feedback on
set pagesize 1000

column Year format 9999
column RegionMonth format a16
column Volume format 999999

column EastJanuary  format 999999
column WestJanuary  format 999999
column NorthJanuary  format 999999
column SouthJanuary  format 999999
column CentralJanuary  format 999999
column EastFebruary  format 999999
column WestFebruary format 999999
column NorthFebruary format 999999
column SouthFebruary format 999999
column CentralFebruary format 999999
column EastMarch format 999999
column WestMarch format 999999
column NorthMarch format 999999
column SouthMarch format 999999
column CentralMarch format 999999
column EastApril format 999999
column WestApril format 999999
column NorthApril format 999999
column SouthApril format 999999
column CentralApril format 999999
column EastMay format 999999
column WestMay format 999999
column NorthMay format 999999
column SouthMay format 999999
column CentralMay format 999999
column EastJune format 999999
column WestJune format 999999
column NorthJune format 999999
column SouthJune format 999999
column CentralJune format 999999
column EastJuly format 999999
column WestJuly format 999999
column NorthJuly format 999999
column SouthJuly format 999999
column CentralJuly format 999999
column EastAugust format 999999
column WestAugust format 999999
column NorthAugust format 999999
column SouthAugust format 999999
column CentralAugust format 999999
column EastSeptember format 999999
column WestSeptember format 999999
column NorthSeptember format 999999
column SouthSeptember format 999999
column CentralSeptember format 999999
column EastOctober format 999999
column WestOctober format 999999
column NorthOctober format 999999
column SouthOctober format 999999
column CentralOctober format 999999
column EastNovember format 999999
column WestNovember format 999999
column NorthNovember format 999999
column SouthNovember format 999999
column CentralNovember format 999999
column EastDecember format 999999
column WestDecember format 999999
column NorthDecember format 999999
column SouthDecember format 999999
column CentralDecember format 999999

prompt Annual Sales
select "Year", "Volume"
from annual_sales_v
order by "Volume";

prompt Regional Monthly Sales
prompt East region monthly sales
select 
    "Year", 
    "EastJanuary", "EastFebruary", "EastMarch",
    "EastApril", "EastMay", "EastJune"
from regional_monthly_sales_v
order by "Year";

select 
    "Year", 
    "EastJuly", "EastAugust", "EastSeptember",
    "EastOctober", "EastNovember", "EastDecember"
from regional_monthly_sales_v
order by "Year";

prompt West region monthly sales
select 
    "Year", 
    "WestJanuary", "WestFebruary", "WestMarch", 
    "WestApril", "WestMay", "WestJune"
from regional_monthly_sales_v
order by "Year";

select 
    "Year", 
    "WestJuly", "WestAugust", "WestSeptember",
    "WestOctober", "WestNovember", "WestDecember"
from regional_monthly_sales_v
order by "Year";

prompt North region monthly sales
select 
    "Year", 
    "NorthJanuary", "NorthFebruary", "NorthMarch", 
    "NorthApril", "NorthMay", "NorthJune"
from regional_monthly_sales_v
order by "Year";

select 
    "Year", 
    "NorthJuly", "NorthAugust", "NorthSeptember",
    "NorthOctober", "NorthNovember", "NorthDecember"
from regional_monthly_sales_v
order by "Year";

prompt South region monthly sales
select 
    "Year", 
    "SouthJanuary", "SouthFebruary", "SouthMarch", 
    "SouthApril", "SouthMay", "SouthJune"
from regional_monthly_sales_v
order by "Year";

select 
    "Year", 
    "SouthJuly", "SouthAugust", "SouthSeptember",
    "SouthOctober", "SouthNovember", "SouthDecember"
from regional_monthly_sales_v
order by "Year";

prompt Central region monthly sales
select 
    "Year", 
    "CentralJanuary", "CentralFebruary", "CentralMarch", 
    "CentralApril", "CentralMay", "CentralJune"
from regional_monthly_sales_v
order by "Year";

select 
    "Year", 
    "CentralJuly", "CentralAugust", "CentralSeptember",
    "CentralOctober", "CentralNovember", "CentralDecember"
from regional_monthly_sales_v
order by "Year";

prompt Add each regional monthly column to validate yearly totals
select 
    "Year", 
     (
        "EastJanuary" + "WestJanuary" + "NorthJanuary" + "SouthJanuary" + "CentralJanuary" +
        "EastFebruary" + "WestFebruary" + "NorthFebruary" + "SouthFebruary" + "CentralFebruary" +
        "EastMarch" + "WestMarch" + "NorthMarch" + "SouthMarch" + "CentralMarch" +
        "EastApril" + "WestApril" + "NorthApril" + "SouthApril" + "CentralApril" +
        "EastMay" + "WestMay" + "NorthMay" + "SouthMay" + "CentralMay" +
        "EastJune" + "WestJune" + "NorthJune" + "SouthJune" + "CentralJune" +
        "EastJuly" + "WestJuly" + "NorthJuly" + "SouthJuly" + "CentralJuly" +
        "EastAugust" + "WestAugust" + "NorthAugust" + "SouthAugust" + "CentralAugust" +
        "EastSeptember" + "WestSeptember" + "NorthSeptember" + "SouthSeptember" + "CentralSeptember" +
        "EastOctober" + "WestOctober" + "NorthOctober" + "SouthOctober" + "CentralOctober" +
        "EastNovember" + "WestNovember" + "NorthNovember" + "SouthNovember" + "CentralNovember" +
        "EastDecember" + "WestDecember" + "NorthDecember" + "SouthDecember" + "CentralDecember"
    ) as "Volume"
from regional_monthly_sales_v
order by "Year";

prompt Unpivot Regional monthly Sales
select "Year", "Volume", "RegionMonth"
from
    regional_monthly_sales_v
    unpivot (
        "Volume" for "RegionMonth" in (
            "EastJanuary", "WestJanuary", "NorthJanuary", "SouthJanuary", "CentralJanuary",
            "EastFebruary", "WestFebruary", "NorthFebruary", "SouthFebruary", "CentralFebruary",
            "EastMarch", "WestMarch", "NorthMarch", "SouthMarch", "CentralMarch",
            "EastApril", "WestApril", "NorthApril", "SouthApril", "CentralApril",
            "EastMay", "WestMay", "NorthMay", "SouthMay", "CentralMay",
            "EastJune", "WestJune", "NorthJune", "SouthJune", "CentralJune",
            "EastJuly", "WestJuly", "NorthJuly", "SouthJuly", "CentralJuly",
            "EastAugust", "WestAugust", "NorthAugust", "SouthAugust", "CentralAugust",
            "EastSeptember", "WestSeptember", "NorthSeptember", "SouthSeptember", "CentralSeptember",
            "EastOctober", "WestOctober", "NorthOctober", "SouthOctober", "CentralOctober",
            "EastNovember", "WestNovember", "NorthNovember", "SouthNovember", "CentralNovember",
            "EastDecember", "WestDecember", "NorthDecember", "SouthDecember", "CentralDecember"
            )
    );

prompt Unpivot each regional monthly column to validate yearly totals
with unpivoted_sales as (
    select "Year", "Volume", "RegionMonth"
    from
        regional_monthly_sales_v
        unpivot (
            "Volume" for "RegionMonth" in (
                "EastJanuary", "WestJanuary", "NorthJanuary", "SouthJanuary", "CentralJanuary",
                "EastFebruary", "WestFebruary", "NorthFebruary", "SouthFebruary", "CentralFebruary",
                "EastMarch", "WestMarch", "NorthMarch", "SouthMarch", "CentralMarch",
                "EastApril", "WestApril", "NorthApril", "SouthApril", "CentralApril",
                "EastMay", "WestMay", "NorthMay", "SouthMay", "CentralMay",
                "EastJune", "WestJune", "NorthJune", "SouthJune", "CentralJune",
                "EastJuly", "WestJuly", "NorthJuly", "SouthJuly", "CentralJuly",
                "EastAugust", "WestAugust", "NorthAugust", "SouthAugust", "CentralAugust",
                "EastSeptember", "WestSeptember", "NorthSeptember", "SouthSeptember", "CentralSeptember",
                "EastOctober", "WestOctober", "NorthOctober", "SouthOctober", "CentralOctober",
                "EastNovember", "WestNovember", "NorthNovember", "SouthNovember", "CentralNovember",
                "EastDecember", "WestDecember", "NorthDecember", "SouthDecember", "CentralDecember"
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