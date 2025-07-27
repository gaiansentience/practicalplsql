

--2.01.02.quantize-vector.sql

--serialize the vector as text and use with json constructor
with base as (
    select 
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
)
select 
    b.id
    , json(
        vector_serialize(b.vec returning clob)
        ) as jvec
from base b
/

