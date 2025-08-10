--design.1.08.pivot-bits-grouped-by-bytes.sql

column byte# format 9
column b#1 format 9
column b#2 format 9
column b#3 format 9
column b#4 format 9
column b#5 format 9
column b#6 format 9
column b#7 format 9
column b#8 format 9

prompt pivot the bit values so that each byte has 8 bits
prompt pivot bit# 0 as bit#8

with base as (
    select
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
), quantized_base as (
    select 
        case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
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
)
select
    p.byte#, p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8
from quantized_base q
pivot(
    max(q.dim_bitval) for bit# in (
        1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
        , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
    ) p
/

/*

pivot the bit values so that each byte has 8 bits
pivot bit# 0 as bit#8

BYTE# B#1 B#2 B#3 B#4 B#5 B#6 B#7 B#8
----- --- --- --- --- --- --- --- ---
    1   0   0   1   0   1   0   1   0
    2   0   0   1   0   1   0   1   0
         
*/