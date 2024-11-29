prompt design-9.6-dynamic_json-test.sql

spool ./design-9.6-dynamic_json_test.txt
prompt design-9.6-dynamic_json_test.txt

set feedback on

column Report format a30
column Year format 99999
column Quarter format a9
column Volume format 999999
set pagesize 100

prompt dynamically unpivot Quarterly Sales
with quarterly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from quarterly_sales_v s
), quarterly_unpivot as (
select 
    u.row#id as "Year", 
    u.column#key as "Quarter", 
    to_number(u.column#value) as "Volume"
from
    quarterly_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
)
select "Year", "Quarter", "Volume"
from quarterly_unpivot
order by "Year", "Quarter";

prompt Validate yearly totals for Quarterly Sales using dynamic unpivot
with quarterly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from quarterly_sales_v s
), quarterly_unpivot as (
select 
    u.row#id as "Year", 
    to_number(u.column#value) as "Volume"
from
    quarterly_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
)
select "Year", sum("Volume") as "Volume"
from quarterly_unpivot
group by "Year"
order by "Year";

prompt compare to the yearly totals view
select "Year", "Volume"
from annual_sales_v
order by "Year";

prompt validate all the pivot reports together
with quarterly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from quarterly_sales_v s
), quarterly_unpivot as (
    select 
        'Quarterly Sales' as "Report",
        u.row#id as "Year", 
        to_number(u.column#value) as "Volume"
    from
        quarterly_json j,
        dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
), regional_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_sales_v s
), regional_unpivot as (
    select 
        'Regional Sales' as "Report",
        u.row#id as "Year", 
        to_number(u.column#value) as "Volume"
    from
        regional_json j,
        dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
), regional_quarterly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_quarterly_sales_v s
), regional_quarterly_unpivot as (
    select 
        'Regional Quarterly Sales' as "Report",
        u.row#id as "Year", 
        to_number(u.column#value) as "Volume"
    from
        regional_quarterly_json j,
        dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
), monthly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from monthly_sales_v s
), monthly_unpivot as (
    select 
        'Monthly Sales' as "Report",
        u.row#id as "Year", 
        to_number(u.column#value) as "Volume"
    from
        monthly_json j,
        dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
), regional_monthly_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_monthly_sales_v s
), regional_monthly_unpivot as (
    select 
        'Regional Monthly Sales' as "Report",
        u.row#id as "Year", 
        to_number(u.column#value) as "Volume"
    from
        regional_monthly_json j,
        dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
), all_unpivots as (
    select "Report", "Year", "Volume" from quarterly_unpivot
    union all
    select "Report", "Year", "Volume" from regional_unpivot
    union all
    select "Report", "Year", "Volume" from regional_quarterly_unpivot
    union all
    select "Report", "Year", "Volume" from monthly_unpivot
    union all
    select "Report", "Year", "Volume" from regional_monthly_unpivot
    union all
    select 'Annual Sales View' as "Report", "Year", "Volume" from annual_sales_v
)
select "Report", "Year", sum("Volume") as "Volume"
from all_unpivots
group by "Report", "Year"
order by "Year", "Report";

--regional monthly final unpivot query went over 4000 characters
--ORA-06502: PL/SQL: value or conversion error: character string buffer too small
--ORA-06512: at "CLOUD_PRACTICALPLSQL.DYNAMIC_JSON", line 176
--create a subtype for sql_text varchar2(32000) and use it for any sql


spool off