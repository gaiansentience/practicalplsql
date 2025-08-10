

--2.01.02.quantize-vector.sql

column value_as_vector format a30
column value_as_json format a30

prompt serialize the vector as text and use with json constructor
with base as (
    select 
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as value_as_vector
)
select 
    b.value_as_vector
    , json(
        vector_serialize(b.value_as_vector returning clob)
        ) as value_as_json
from base b
/

