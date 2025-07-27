

--2.01.03.quantize-vector.sql

--use json_table to separate the array into its dimensions, with one dimension per row
with base as (
    select 
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
), jbase as (
    select
        b.id
        , json(
            vector_serialize(b.vec returning clob)
            ) as jvec
    from base b
)
select b.id, jt.dim#, jt.dimval
from 
    jbase b,
    json_table (
        b.jvec, '$[*]'
        columns(
            dim# for ordinality
            , dimval number path '$'
            )
        ) jt
/

