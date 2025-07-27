
    
--2.01.12.quantize-vector.sql

--substitute the recipes table for the literal test vectors
--result quantizes each float32 vector to binary dimension format
with base as (
    select
        r.id
        , r.embedding as vec
    from recipes r
), quantized_base as (
    select 
        b.id
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
), pivot_to_bytes as (
    select
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
)
select 
    pb.id
    , to_vector(
        json_serialize(
            json_arrayagg(pb.uint_byte order by pb.byte#) 
            returning clob)
        , *, binary) as binary_vector
from pivot_to_bytes pb
group by pb.id
/

