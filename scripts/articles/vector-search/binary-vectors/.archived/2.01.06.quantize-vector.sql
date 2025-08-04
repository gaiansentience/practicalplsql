--design.1.06.verify-bytes-using-16-dimensions.sql

Prompt use a vector with 16 dimensions to confirm that bytes are correctly identified
with base as (
    select
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
)
select 
    b.id
    , jt.dim#
    , jt.dimval
    , case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
    , mod(jt.dim#, 8) as bit#
    , ceil(jt.dim#/8) as byte#
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

