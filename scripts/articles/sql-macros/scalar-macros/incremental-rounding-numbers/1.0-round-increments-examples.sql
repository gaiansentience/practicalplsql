--1.0-round-increments-examples.sql

set serveroutput on;
begin
    dbms_output.put_line( round( 13/5 ) * 5 );
    dbms_output.put_line( round( 1.217/0.25 ) * 0.25 );
end;
/

/*
15
1.25
*/

with base(n, i) as (
    values (13, 5), (1.217, .25)
)
select 
    n as "number"
    , i as "increment"
    , round( n/i ) * i as "result"
from base
/

/*
    number  increment    rounded
---------- ---------- ----------
        13          5         15
     1.217        .25       1.25
*/
