--test.function.to_binary_vector.sql

column binary_vector format a30
column my_binary_vector format a30


prompt test the scalar macro

prompt check with binary for 42  
prompt input vector is [0,0,1,0,1,0,1,0]
select 
    to_binary_vector(
        to_vector('[0,0,1,0,1,0,1,0]',*, int8) 
        ) as binary_vector
/

prompt check with the test vector that should return [42, 42]
prompt input vector is [-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]
with base as (
    select
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , *, int8) as vec
)
select 
    to_binary_vector(b.vec) as my_binary_vector
from base b
/


/*
test the scalar macro
check with binary for 42
input vector is [0,0,1,0,1,0,1,0]

BINARY_VECTOR                 
------------------------------
[42]

check with the test vector that should return [42, 42]
input vector is [-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]

MY_BINARY_VECTOR              
------------------------------
[42,42]


*/