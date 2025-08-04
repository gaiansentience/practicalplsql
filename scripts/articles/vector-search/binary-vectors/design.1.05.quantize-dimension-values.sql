--design.1.05.quantize-dimension-values.sql

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

/*

quantize the array elements
group bits into bytes
identify groups (bytes) of 8 dimensions (bits) to pack into uint8 values
using mod(dim#,8) shows the 8th dimension as bit#0

        ID       DIM#     DIMVAL DIM_BITVAL       BIT#      BYTE#
---------- ---------- ---------- ---------- ---------- ----------
         1          1        -22          0          1          1
         1          2        -44          0          2          1
         1          3         33          1          3          1
         1          4        -13          0          4          1
         1          5         26          1          5          1
         1          6        -11          0          6          1
         1          7         38          1          7          1
         1          8         -7          0          0          1

8 rows selected. 


*/