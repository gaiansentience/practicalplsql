

--2.01.04.quantize-vector.sql

--combine the jbase CTE with the final select to condense the sql
with base as (
    select 
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
)
select b.id, jt.dim#, jt.dimval
from 
    base b,
    json_table (
        json(vector_serialize(b.vec returning clob))
        , '$[*]'
        columns(
            dim# for ordinality
            , dimval number path '$'
            )
        ) jt
/

