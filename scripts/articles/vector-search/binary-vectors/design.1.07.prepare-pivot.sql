--design.1.07.prepare-pivot.sql

set pagesize 50

prompt prepare to pivot the bit values fro quantized_base, 
prompt remove dim# and dimval columns to prevent unecessary grouping levels in the pivot
with base as (
    select
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
), quantized_base as (
    select 
        b.id
        --, jt.dim#, jt.dimval
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
)
select
    b.id
    , b.dim_bitval
    , b.bit#
    , b.byte#
from quantized_base b
order by b.byte#, decode(b.bit#, 0, 8, b.bit#)
/

/*

prepare to pivot the bit values fro quantized_base,
remove dim# and dimval columns to prevent unecessary grouping levels in the pivot

        ID DIM_BITVAL       BIT#      BYTE#
---------- ---------- ---------- ----------
         1          0          1          1
         1          0          2          1
         1          1          3          1
         1          0          4          1
         1          1          5          1
         1          0          6          1
         1          1          7          1
         1          0          0          1
         1          0          1          2
         1          0          2          2
         1          1          3          2
         1          0          4          2
         1          1          5          2
         1          0          6          2
         1          1          7          2
         1          0          0          2

16 rows selected. 


*/