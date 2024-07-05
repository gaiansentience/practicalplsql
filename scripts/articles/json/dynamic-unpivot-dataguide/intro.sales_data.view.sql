prompt intro.sales_data.view.sql


prompt create a sample datasource for sales data
create or replace view sales_data_v as
with sales_months (m) as (
    select level
    from dual
    connect by level <= 12
), sales_years (y) as (
    select 2020 + level
    from dual connect by level <= 3
), sales_data as (
    select
        y as "Year", 
        to_date(y || m, 'YYYYMM') as "Month", 
        round(dbms_random.value(1000, 20000)) as "Volume"
    from 
        sales_years 
        cross join sales_months
)
select "Year", "Month", "Volume"
from sales_data
/

prompt create a datasource with pivoted quarterly sales

create or replace view quarterly_sales_v as
with sales_data as (
    select
        "Year", 
        to_char("Month", 'Q') as "Quarter", 
        sum("Volume") as "Volume"
    from sales_data_v 
    group by "Year", to_char("Month", 'Q')
), quarterly_sales as (
    select "Year", "Qtr1", "Qtr2", "Qtr3", "Qtr4"
    from
        sales_data
        pivot (
            sum("Volume") for "Quarter" in (
                '1' as "Qtr1", '2' as "Qtr2", '3' as "Qtr3", '4' as "Qtr4"
            )
        )
)
select * 
from quarterly_sales
order by "Year"
/

prompt create a datasource with pivoted monthly sales
create or replace view monthly_sales_v as
with sales_data as (
    select
        "Year", 
        to_char("Month", 'fmMonth', 'NLS_DATE_LANGUAGE = American' ) as "Month", 
        "Volume"
    from sales_data_v 
), monthly_sales as (
    select 
        "Year", 
        "January", "February", "March", 
        "April", "May", "June",
        "July", "August", "September",
        "October", "November", "December"
    from
        sales_data
        pivot (
            sum("Volume") for "Month" in (
                'January' as "January", 'February' as "February", 'March' as "March",
                'April' as "April", 'May' as "May", 'June' as "June",
                'July' as "July", 'August' as "August", 'September' as "September",
                'October' as "October", 'November' as "November", 'December' as "December"
            )
        )
)
select * 
from monthly_sales
order by "Year"
/

