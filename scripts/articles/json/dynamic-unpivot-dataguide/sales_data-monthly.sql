prompt sales_data-monthly.sql
prompt run sales_data.report_sources.sql to create pivoted data sources

spool .\sales_data-monthly.txt
prompt sales_data-monthly.txt

set feedback on
set pagesize 1000

column Year format 99999
column Month format a10
column Volume format 999999

column January format 99999
column February format 99999
column March format 99999
column April format 99999
column May format 99999
column June format 99999
column July format 99999
column August format 99999
column September format 99999
column October format 99999
column November format 99999
column December format 99999

prompt Annual Sales
select "Year", "Volume"
from annual_sales_v
order by "Volume";


prompt Monthly Sales
select 
    "Year",
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"        
from monthly_sales_v
order by "Year";

prompt Add each monthly column to validate yearly totals
select 
    "Year", 
    (
        "January" + "February" + "March" + "April" + "May" + "June" +
        + "July" + "August" + "September" + "October" + "November" + "December"
    ) as "Volume"
from monthly_sales_v
order by "Year";

prompt Unpivot Monthly Sales
select "Year", "Month", "Volume"
from
    monthly_sales_v
    unpivot (
        "Volume" for "Month" in (
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"        
            )
    );

prompt Unpivot each monthly column to validate yearly totals
with unpivoted_sales as (
    select "Year", "Month", "Volume"
    from
        monthly_sales_v
        unpivot (
            "Volume" for "Month" in (
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"        
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