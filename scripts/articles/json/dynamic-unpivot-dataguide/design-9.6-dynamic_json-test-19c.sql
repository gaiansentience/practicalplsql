prompt design--9.6-dynamic_json-test-19c.sql
prompt for Oracle 19c use clob datatype for json document

spool ./design-9.6-dynamic_json_test-19c.txt
prompt design-9.6-dynamic_json_test-19c.txt

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
    select 
        json_object(
            'SalesHistory' : 
                json_arrayagg(
                    json_object( s.* )
                returning clob)
        returning clob) as jdoc
    from quarterly_sales_v s
)
select u.row#id as "Year", u.column#key as "Quarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/


prompt dynamically unpivot regional totals
with sales_to_json as (
    select 
        json_object(
            'SalesHistory' : 
                json_arrayagg(
                    json_object( s.* )
                returning clob)
        returning clob) as jdoc
    from regional_sales_v s
)
select u.row#id as "Year", u.column#key as "Region", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

prompt dynamically unpivot regional quarterly totals
with sales_to_json as (
    select 
        json_object(
            'SalesHistory' : 
                json_arrayagg(
                    json_object( s.* )
                returning clob)
        returning clob) as jdoc
    from regional_quarterly_sales_v s
)
select u.row#id as "Year", u.column#key as "RegionQuarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

prompt dynamically unpivot monthly totals
with sales_to_json as (
    select 
        json_object(
            'SalesHistory' : 
                json_arrayagg(
                    json_object( s.* )
                returning clob)
        returning clob) as jdoc
    from monthly_sales_v s
)
select u.row#id as "Year", u.column#key as "Month", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

prompt dynamically unpivot monthly totals
with sales_to_json as (
    select 
        json_object(
            'SalesHistory' : 
                json_arrayagg(
                    json_object( s.* )
                returning clob)
        returning clob) as jdoc
    from regional_monthly_sales_v s
)
select u.row#id as "Year", u.column#key as "RegionMonth", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

spool off
