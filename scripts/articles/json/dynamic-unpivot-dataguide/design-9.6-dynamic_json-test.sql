prompt design--9.6-dynamic_json-test.sql

set feedback off
column Year format 99999
column Quarter format a9
column Month format a9
column Volume format 9999999
column Qtr1 format 99999
column Qtr2 format 99999
column Qtr3 format 99999
column Qtr4 format 99999
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
set pagesize 100

prompt reset the random seed to keep values the same for each execution
exec dbms_random.seed('albert einstein');

prompt dynamically unpivot quarterly totals
with sales_to_json as (
    select 
        json{
            'SalesHistory' : 
                json_arrayagg(
                    json{ s.* }
                )
        } as jdoc
    from quarterly_sales_v s
)
select u.row#id as "Year", u.column#key as "Quarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

prompt reset the random seed to keep values the same for each execution
exec dbms_random.seed('albert einstein');

prompt dynamically unpivot quarterly totals and check yearly totals
with sales_to_json as (
    select 
        json{
            'SalesHistory' : 
                json_arrayagg(
                    json{ s.* }
                )
        } as jdoc
    from quarterly_sales_v s
), unpivoted_sales as (
select u.row#id as "Year", u.column#key as "Quarter", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
)
select "Year", sum("Volume") as "Volume"
from unpivoted_sales
group by "Year"
/

prompt reset the random seed to keep values the same for each execution
exec dbms_random.seed('albert einstein');

prompt dynamically unpivot monthly totals
with sales_to_json as (
    select 
        json{
            'SalesHistory' : 
                json_arrayagg(
                    json{ s.* }
                )
        } as jdoc
    from monthly_sales_v s
)
select u.row#id as "Year", u.column#key as "Month", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
/

prompt reset the random seed to keep values the same for each execution
exec dbms_random.seed('albert einstein');

prompt dynamically unpivot monthly totals and check yearly totals
with sales_to_json as (
    select 
        json{
            'SalesHistory' : 
                json_arrayagg(
                    json{ s.* }
                )
        } as jdoc
    from monthly_sales_v s
), unpivoted_sales as (
select u.row#id as "Year", u.column#key as "Month", to_number(u.column#value) as "Volume"
from
    sales_to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year', '.SalesHistory') u
)
select "Year", sum("Volume") as "Volume"
from unpivoted_sales
group by "Year"
/

/*
design--9.6-dynamic_json-test.sql
reset the random seed to keep values the same for each execution
dynamically unpivot quarterly totals

  Year Quarter     Volume
------ --------- --------
  2021 Qtr1         31782
  2021 Qtr2         30218
  2021 Qtr3         51584
  2021 Qtr4         50833
  2022 Qtr1         40282
  2022 Qtr2         42327
  2022 Qtr3         48088
  2022 Qtr4         33479
  2023 Qtr1         39260
  2023 Qtr2         39493
  2023 Qtr3         27748
  2023 Qtr4         20791
reset the random seed to keep values the same for each execution
dynamically unpivot quarterly totals and check yearly totals

  Year   Volume
------ --------
  2021   164417
  2022   164176
  2023   127292
reset the random seed to keep values the same for each execution
dynamically unpivot monthly totals

  Year Month       Volume
------ --------- --------
  2021 April        14144
  2021 August       19965
  2021 December     19549
  2021 February      1410
  2021 January      12494
  2021 July         13783
  2021 June          6654
  2021 March        17878
  2021 May           9420
  2021 November     12985
  2021 October      18299
  2021 September    17836
  2022 April         7509
  2022 August       19124
  2022 December      6745
  2022 February     12154
  2022 January      14866
  2022 July         11543
  2022 June         18962
  2022 March        13262
  2022 May          15856
  2022 November      9847
  2022 October      16887
  2022 September    17421
  2023 April        17796
  2023 August        2836
  2023 December      3796
  2023 February     12629
  2023 January      13010
  2023 July         19744
  2023 June          3032
  2023 March        13621
  2023 May          18665
  2023 November      1447
  2023 October      15548
  2023 September     5168
reset the random seed to keep values the same for each execution
dynamically unpivot monthly totals and check yearly totals

  Year   Volume
------ --------
  2021   164417
  2022   164176
  2023   127292

*/