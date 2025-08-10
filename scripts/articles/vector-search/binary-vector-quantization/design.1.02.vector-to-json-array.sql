--design.1.02.vector-to-json-array.sql

column value_as_vector format a30
column value_as_json format a30

prompt serialize the vector as text and use with json constructor
with base as (
    select 
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vector_value
)
select 
    vector_serialize(b.vector_value) as value_as_vector
    , json_serialize(
        json(
            vector_serialize(b.vector_value returning clob)
        )
    ) as value_as_json
from base b
/

/*

serialize the vector as text and use with json constructor

VALUE_AS_VECTOR                VALUE_AS_JSON                 
------------------------------ ------------------------------
[-22,-44,33,-13,26,-11,38,-7]  [-22,-44,33,-13,26,-11,38,-7] 

*/