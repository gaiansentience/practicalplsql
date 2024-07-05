prompt intro.unpivoting_data.sql
prompt run intro.sales_data.view.sql to create pivoted data sources

set feedback off
column Year format 99999
column Quarter format a9
column Month format a9
column Volume format 99999
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

prompt reset the random seed before each execution
exec dbms_random.seed('albert einstein');

prompt datasource with pivoted quarterly sales
select * from quarterly_sales_v
order by "Year"
/

prompt reset the random seed before each execution
exec dbms_random.seed('albert einstein');

prompt unpivot quarterly sales
select "Year", "Quarter", "Volume"
from 
    quarterly_sales_v
    unpivot (
        "Volume" for "Quarter" in ("Qtr1", "Qtr2", "Qtr3", "Qtr4")
    )
order by "Year", "Quarter"
/
prompt reset the random seed before each execution
exec dbms_random.seed('albert einstein');

prompt datasource with pivoted monthly sales
select * from monthly_sales_v
order by "Year"
/

prompt reset the random seed before each execution
exec dbms_random.seed('albert einstein');

prompt unpivot monthly sales
select "Year", "Month", "Volume"
from
    monthly_sales_v
    unpivot (
        "Volume" for "Month" in (
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"        
            )
    )
order by "Year", "Month"
/

/*
intro.unpivoting_data.sql
run intro.sales_data.view.sql to create pivoted data sources
reset the random seed before each execution
datasource with pivoted quarterly sales

  Year   Qtr1   Qtr2   Qtr3   Qtr4
------ ------ ------ ------ ------
  2021  31782  30218  51584  50833
  2022  40282  42327  48088  33479
  2023  39260  39493  27748  20791
reset the random seed before each execution
unpivot quarterly sales

  Year Quarter   Volume
------ --------- ------
  2021 Qtr1       31782
  2021 Qtr2       30218
  2021 Qtr3       51584
  2021 Qtr4       50833
  2022 Qtr1       40282
  2022 Qtr2       42327
  2022 Qtr3       48088
  2022 Qtr4       33479
  2023 Qtr1       39260
  2023 Qtr2       39493
  2023 Qtr3       27748
  2023 Qtr4       20791
reset the random seed before each execution
datasource with pivoted monthly sales

  Year January February  March  April    May   June   July August September October November December
------ ------- -------- ------ ------ ------ ------ ------ ------ --------- ------- -------- --------
  2021   12494     1410  17878  14144   9420   6654  13783  19965     17836   18299    12985    19549
  2022   14866    12154  13262   7509  15856  18962  11543  19124     17421   16887     9847     6745
  2023   13010    12629  13621  17796  18665   3032  19744   2836      5168   15548     1447     3796
reset the random seed before each execution
unpivot monthly sales

  Year Month     Volume
------ --------- ------
  2021 April      14144
  2021 August     19965
  2021 December   19549
  2021 February    1410
  2021 January    12494
  2021 July       13783
  2021 June        6654
  2021 March      17878
  2021 May         9420
  2021 November   12985
  2021 October    18299
  2021 September  17836
  2022 April       7509
  2022 August     19124
  2022 December    6745
  2022 February   12154
  2022 January    14866
  2022 July       11543
  2022 June       18962
  2022 March      13262
  2022 May        15856
  2022 November    9847
  2022 October    16887
  2022 September  17421
  2023 April      17796
  2023 August      2836
  2023 December    3796
  2023 February   12629
  2023 January    13010
  2023 July       19744
  2023 June        3032
  2023 March      13621
  2023 May        18665
  2023 November    1447
  2023 October    15548
  2023 September   5168

*/