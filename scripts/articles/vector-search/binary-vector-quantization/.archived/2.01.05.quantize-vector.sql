--design.1.5-quantize-dimension-values.sql

prompt quantize the array elements
prompt group bits into bytes
prompt identify groups (bytes) of 8 dimensions (bits) to pack into uint8 values
prompt using mod(dim#,8) shows the 8th dimension as bit#0
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

