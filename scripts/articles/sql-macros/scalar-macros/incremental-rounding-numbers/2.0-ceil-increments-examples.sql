--2.0-ceil-increments-examples.sql

set serveroutput on;
begin
    dbms_output.put_line( ceil( 7/5 ) * 5 );
    dbms_output.put_line( ceil( 1.08/ 1/4 ) * 1/4 );
end;
/

/*
10
.25
*/

with base(n, i) as (
    select 7, 5 from dual union all
    select 1.08, .25 from dual
)
select 
    n as "number"
    , i as "increment"
    , ceil( n/i ) * i as "result"
from base
/

/*
    number  increment     result
---------- ---------- ----------
         7          5         10
      1.08        .25       1.25
*/
