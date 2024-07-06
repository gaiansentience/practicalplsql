prompt sales_data-quarterly.sql
prompt run sales_data.report_sources.sql to create pivoted data sources

spool .\sales_data-quarterly.txt
prompt sales_data-quarterly.txt

set feedback on
set pagesize 1000

column Year format 99999
column Quarter format a9
column Volume format 999999

column Qtr1 format 999999
column Qtr2 format 999999
column Qtr3 format 999999
column Qtr4 format 999999

prompt Annual Sales
select "Year", "Volume"
from annual_sales_v
order by "Volume";

prompt Quarterly Sales
select 
    "Year", "Qtr1", "Qtr2", "Qtr3", "Qtr4" 
from quarterly_sales_v
order by "Year";

prompt Add each quarterly column to validate yearly totals
select 
    "Year", 
    (
        "Qtr1" + "Qtr2" + "Qtr3" + "Qtr4"
    ) as "Volume"
from quarterly_sales_v
order by "Year";

prompt Unpivot Quarterly Sales
select "Year", "Quarter", "Volume"
from 
    quarterly_sales_v
    unpivot (
        "Volume" for "Quarter" in (
            "Qtr1", "Qtr2", "Qtr3", "Qtr4")
    )
order by "Year", "Quarter";

prompt Unpivot each quarterly column to validate yearly totals
with unpivot_sales as (
    select "Year", "Quarter", "Volume"
    from 
        quarterly_sales_v
        unpivot (
            "Volume" for "Quarter" in (
                "Qtr1", "Qtr2", "Qtr3", "Qtr4")
        )
)
select 
    "Year", 
    sum("Volume") as "Volume"
from unpivot_sales
group by "Year"
order by "Year";

spool off