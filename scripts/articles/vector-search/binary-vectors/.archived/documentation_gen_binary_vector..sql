select * from user_tables where table_name not like '%$%';

select * from genbvec;

select * from genbvec_i;

11100100101001001010010111110010

11100100
10100100
10100101
11110010

select bin_to_num(1,1,1,0,0,1,0,0);
select bin_to_num(1,0,1,0,0,1,0,0);
select bin_to_num(1,0,1,0,0,1,0,1);
select bin_to_num(1,1,1,1,0,0,1,0);

with base (b0,b1,b2,b3,b4,b5,b6,b7) as (
values
(1,1,1,0,0,1,0,0),
(1,0,1,0,0,1,0,0),
(1,0,1,0,0,1,0,1),
(1,1,1,1,0,0,1,0)
)
select bin_to_num(b0,b1,b2,b3,b4,b5,b6,b7) as int8, bin_to_num(b7,b6,b5,b4,b3,b2,b1,b0) as reversedint8
from base
/


[39,37,165,79]