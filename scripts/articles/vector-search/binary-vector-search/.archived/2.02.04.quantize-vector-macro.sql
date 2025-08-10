

--2.02.04.quantize-vector-macro.sql

--check with binary for 42:
select 
    to_binary_vector(
        to_vector('[0,0,1,0,1,0,1,0]',*, int8) 
        ) as binary_vector
/

--check with the test vector that should return [42, 42]
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

--try it with the recipes table
select 
    r.id
    , r.name
    , to_binary_vector(r.embedding) as binary_embedding
from recipes r
order by r.name
/


