

--2.01.10.quantize-vector.sql

--use json_arrayagg to combine the bytes into an array
--serialize this as textual input for the binary vector
with base as (
    select
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
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
    id
    , json_serialize(
        json_arrayagg(uint_byte order by byte#) 
        returning clob) as textual_input
from pivot_to_bytes
group by id
/

