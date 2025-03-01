--1.0-floor-increments-examples.sql

set serveroutput on;
declare
    n number;
    i number;
    r number;
begin
    n := 7;
    i := 5;
    r := floor( n/i ) * i;
    dbms_output.put_line('floor: ' || n || ' to increments of ' || i || ' = ' || r);

    n := 1.08;
    i := 0.25;
    r := floor( n/i ) * i;
    dbms_output.put_line('floor: ' || n || ' to increments of ' || i || ' = ' || r);
end;
/

/*
floor: 7 to increments of 5 = 5
floor: 1.08 to increments of .25 = 1
*/

with base(n, i) as (
select 7, 5 from dual union all
select 1.08, .25 from dual
)
select n, i, floor( n/i ) * i as r
from base
/

/*
         N          I          R
---------- ---------- ----------
         7          5          5
      1.08        .25          1
*/
