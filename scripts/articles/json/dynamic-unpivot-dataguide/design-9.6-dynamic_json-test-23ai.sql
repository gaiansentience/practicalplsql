prompt design--9.6-dynamic_json-test-23ai.sql
prompt for Oracle 23ai use json datatype for json document

spool ./design-9.6-dynamic_json_test-23ai.txt
prompt design-9.6-dynamic_json_test-23ai.txt

set feedback on 

column Year format 9999
column Quarter format a9
column Month format a9
column Region format a9
column RegionQuarter format a15
column RegionMonth format a20
column Volume format 999999

set pagesize 1000


prompt dynamically unpivot quarterly totals
with sales_to_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from quarterly_sales_v s
)
select u.row#id as "Year", u.column#key as "Quarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
/


prompt dynamically unpivot regional totals
with sales_to_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_sales_v s
)
select u.row#id as "Year", u.column#key as "Region", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
/

prompt dynamically unpivot regional quarterly totals
with sales_to_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_quarterly_sales_v s
)
select u.row#id as "Year", u.column#key as "RegionQuarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
/

prompt dynamically unpivot monthly totals
with sales_to_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from monthly_sales_v s
)
select u.row#id as "Year", u.column#key as "Month", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
/

prompt dynamically unpivot monthly totals
with sales_to_json as (
    select json{ 'jSales' : json_arrayagg( json{ s.* } ) } as jdoc
    from regional_monthly_sales_v s
)
select u.row#id as "Year", u.column#key as "RegionMonth", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.jSales') u
/

spool off
