prompt sales_data.report_sources.sql


declare
    i number;
begin

$if dbms_db_version.version < 23 $then
    select count(*) into i
    from user_tables 
    where table_name = 'SALES_DATA';
    if i > 0 then
        execute immediate 'drop table sales_data purge';
    end if;
$else
    execute immediate 'drop table if exists sales_data purge';
$end

end;
/

prompt set the random seed so generated data is always the same
exec dbms_random.seed('albert einstein');

create table sales_data as
with sales_months (m) as (
    select level
    from dual
    connect by level <= 12
), sales_years (y) as (
    select 2020 + level
    from dual connect by level <= 3
), sales_regions as (
    select 
        case level 
            when 1 then 'Central' 
            when 2 then 'East' 
            when 3 then 'West' 
            when 4 then 'North' 
            when 5 then 'South' 
        end as r
    from dual connect by level <=5
), sales_data_source as (
    select
        r as "Region",
        y as "Year", 
        to_date(y || m, 'YYYYMM') as "MonthDate", 
        round(dbms_random.value(100, 20000)) as "Volume"
    from 
        sales_years 
        cross join sales_months
        cross join sales_regions
)
select 
    "Region", 
    "Year", 
    "MonthDate", 
    to_char("MonthDate", 'fmMonth', 'NLS_DATE_LANGUAGE = American' ) as "Month", 
    to_char("MonthDate", 'Q') as "Quarter", 
    "Volume"
from sales_data_source
/

prompt create a datasource with annual sales
create or replace view annual_sales_v as
select "Year", sum("Volume") as "Volume"
from sales_data
group by "Year"
order by "Year";

prompt create a datasource with pivoted quarterly sales
create or replace view quarterly_sales_v as
with pivot_base as (
    select "Year", "Quarter", "Volume" 
    from sales_data
), quarterly_sales as (
    select "Year", "Qtr1", "Qtr2", "Qtr3", "Qtr4"
    from
        pivot_base
        pivot (
            sum("Volume") for "Quarter" in (
                '1' as "Qtr1", 
                '2' as "Qtr2", 
                '3' as "Qtr3", 
                '4' as "Qtr4"
            )
        )
)
select "Year", "Qtr1", "Qtr2", "Qtr3", "Qtr4" 
from quarterly_sales
order by "Year"
/

prompt create a datasource with pivoted regional sales
create or replace view regional_sales_v as
with pivot_base as (
    select "Year", "Region", "Volume" 
    from sales_data
), regional_sales as (
    select "Year", "East", "West", "North", "South", "Central"
    from
        pivot_base
        pivot (
            sum("Volume") for "Region" in (
                'East' as "East", 
                'West' as "West", 
                'North' as "North", 
                'South' as "South",
                'Central' as "Central"
            )
        )
)
select "Year", "East", "West", "North", "South", "Central"
from regional_sales
order by "Year"
/

create or replace view regional_quarterly_sales_v as 
with pivot_base as (
    select "Year", "Region", "Quarter", "Volume" 
    from sales_data
), regional_quarterly_sales as (
    select 
        "Year", 
        "EastQtr1", "WestQtr1", "NorthQtr1", "SouthQtr1", "CentralQtr1",
        "EastQtr2", "WestQtr2", "NorthQtr2", "SouthQtr2", "CentralQtr2",
        "EastQtr3", "WestQtr3", "NorthQtr3", "SouthQtr3", "CentralQtr3",
        "EastQtr4", "WestQtr4", "NorthQtr4", "SouthQtr4", "CentralQtr4"
    from
        pivot_base
        pivot (
            sum("Volume") for ("Quarter", "Region") in (
                ('1', 'East') as "EastQtr1", 
                ('1', 'West') as "WestQtr1", 
                ('1', 'North') as "NorthQtr1", 
                ('1', 'South') as "SouthQtr1", 
                ('1', 'Central') as "CentralQtr1",
                ('2', 'East') as "EastQtr2", 
                ('2', 'West') as "WestQtr2", 
                ('2', 'North') as "NorthQtr2", 
                ('2', 'South') as "SouthQtr2", 
                ('2', 'Central') as "CentralQtr2",
                ('3', 'East') as "EastQtr3", 
                ('3', 'West') as "WestQtr3", 
                ('3', 'North') as "NorthQtr3", 
                ('3', 'South') as "SouthQtr3", 
                ('3', 'Central') as "CentralQtr3",
                ('4', 'East') as "EastQtr4", 
                ('4', 'West') as "WestQtr4", 
                ('4', 'North') as "NorthQtr4", 
                ('4', 'South') as "SouthQtr4", 
                ('4', 'Central') as "CentralQtr4"
            )
        )
)
select 
    "Year", 
    "EastQtr1", "WestQtr1", "NorthQtr1", "SouthQtr1", "CentralQtr1",
    "EastQtr2", "WestQtr2", "NorthQtr2", "SouthQtr2", "CentralQtr2",
    "EastQtr3", "WestQtr3", "NorthQtr3", "SouthQtr3", "CentralQtr3",
    "EastQtr4", "WestQtr4", "NorthQtr4", "SouthQtr4", "CentralQtr4"    
from regional_quarterly_sales
order by "Year"
/


prompt create a datasource with pivoted monthly sales
create or replace view monthly_sales_v as
with pivot_base as (
    select "Year", "Month", "Volume" 
    from sales_data
), monthly_sales as (
    select 
        "Year", 
        "January", "February", "March", 
        "April", "May", "June",
        "July", "August", "September",
        "October", "November", "December"
    from
        pivot_base
        pivot (
            sum("Volume") for "Month" in (
                'January' as "January", 'February' as "February", 'March' as "March",
                'April' as "April", 'May' as "May", 'June' as "June",
                'July' as "July", 'August' as "August", 'September' as "September",
                'October' as "October", 'November' as "November", 'December' as "December"
            )
        )
)
select 
    "Year",
    "January", "February", "March",
    "April", "May", "June",
    "July", "August", "September",
    "October", "November", "December"
from monthly_sales
order by "Year"
/

create or replace view regional_monthly_sales_v as 
with pivot_base as (
    select "Year", "Region", "Month", "Volume" 
    from sales_data
), regional_monthly_sales as (
    select 
        "Year", 
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
    from
        pivot_base
        pivot (
            sum("Volume") for ("Month", "Region") in (
                ('January', 'East') as "EastJanuary", 
                ('January', 'West') as "WestJanuary", 
                ('January', 'North') as "NorthJanuary", 
                ('January', 'South') as "SouthJanuary", 
                ('January', 'Central') as "CentralJanuary",
                ('February', 'East') as "EastFebruary", 
                ('February', 'West') as "WestFebruary", 
                ('February', 'North') as "NorthFebruary", 
                ('February', 'South') as "SouthFebruary", 
                ('February', 'Central') as "CentralFebruary",
                ('March', 'East') as "EastMarch", 
                ('March', 'West') as "WestMarch", 
                ('March', 'North') as "NorthMarch", 
                ('March', 'South') as "SouthMarch", 
                ('March', 'Central') as "CentralMarch",
                ('April', 'East') as "EastApril", 
                ('April', 'West') as "WestApril", 
                ('April', 'North') as "NorthApril", 
                ('April', 'South') as "SouthApril", 
                ('April', 'Central') as "CentralApril",
                ('May', 'East') as "EastMay", 
                ('May', 'West') as "WestMay", 
                ('May', 'North') as "NorthMay", 
                ('May', 'South') as "SouthMay", 
                ('May', 'Central') as "CentralMay",
                ('June', 'East') as "EastJune", 
                ('June', 'West') as "WestJune", 
                ('June', 'North') as "NorthJune", 
                ('June', 'South') as "SouthJune", 
                ('June', 'Central') as "CentralJune",
                ('July', 'East') as "EastJuly", 
                ('July', 'West') as "WestJuly", 
                ('July', 'North') as "NorthJuly", 
                ('July', 'South') as "SouthJuly", 
                ('July', 'Central') as "CentralJuly",
                ('August', 'East') as "EastAugust", 
                ('August', 'West') as "WestAugust", 
                ('August', 'North') as "NorthAugust", 
                ('August', 'South') as "SouthAugust", 
                ('August', 'Central') as "CentralAugust",
                ('September', 'East') as "EastSeptember", 
                ('September', 'West') as "WestSeptember", 
                ('September', 'North') as "NorthSeptember", 
                ('September', 'South') as "SouthSeptember", 
                ('September', 'Central') as "CentralSeptember",
                ('October', 'East') as "EastOctober", 
                ('October', 'West') as "WestOctober", 
                ('October', 'North') as "NorthOctober", 
                ('October', 'South') as "SouthOctober", 
                ('October', 'Central') as "CentralOctober",
                ('November', 'East') as "EastNovember", 
                ('November', 'West') as "WestNovember", 
                ('November', 'North') as "NorthNovember", 
                ('November', 'South') as "SouthNovember", 
                ('November', 'Central') as "CentralNovember",
                ('December', 'East') as "EastDecember", 
                ('December', 'West') as "WestDecember", 
                ('December', 'North') as "NorthDecember", 
                ('December', 'South') as "SouthDecember", 
                ('December', 'Central') as "CentralDecember"
            )
        )
)
select 
    "Year", 
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
from regional_monthly_sales
order by "Year"
/
