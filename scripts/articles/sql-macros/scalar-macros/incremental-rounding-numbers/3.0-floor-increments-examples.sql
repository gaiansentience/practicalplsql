--3.0-floor-increments-examples.sql

set serveroutput on;
declare
    procedure test(n in number, i in number)
    is
    begin
        dbms_output.put('floor ' || n || ' in increments of ' || i || ' = ');
        dbms_output.put_line( floor( n/i ) * i );
    end test;
begin
    test(8.5, 5);
    test(13, 5);
    test(0.42, 0.25);
    test(1.08, 0.25);
    test(-8.5, 5);
    test(-13, 5);
    test(-0.42, 0.25);
    test(-1.08, 0.25);
end;
/

/*
floor 8.5 in increments of 5 = 5
floor 13 in increments of 5 = 10
floor .42 in increments of .25 = .25
floor 1.08 in increments of .25 = 1
floor -8.5 in increments of 5 = -10
floor -13 in increments of 5 = -15
floor -.42 in increments of .25 = -.5
floor -1.08 in increments of .25 = -1.25
*/

with base(n, i) as (
    values 
        (8.5, 5), (13, 5), (0.42, 0.25), (1.08, 0.25),
        (-8.5, 5), (-13, 5), (-0.42, 0.25), (-1.08, 0.25)
)
select 
    n as "number"
    , i as "increment"
    , floor( n/i ) * i as "result"
from base
/

/*
    number  increment     result
---------- ---------- ----------
       8.5          5          5
        13          5         10
       .42        .25        .25
      1.08        .25          1
      -8.5          5        -10
       -13          5        -15
     -0.42        .25       -0.5
     -1.08        .25      -1.25
*/
