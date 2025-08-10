--design.1.06.verify-bytes-using-16-dimensions.sql

set pagesize 50

Prompt use a vector with 16 dimensions to confirm that bytes are correctly identified
with base as (
    select
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
)
select 
    jt.dim#
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

use a vector with 16 dimensions to confirm that bytes are correctly identified

      DIM#     DIMVAL DIM_BITVAL       BIT#      BYTE#
---------- ---------- ---------- ---------- ----------
         1        -22          0          1          1
         2        -44          0          2          1
         3         33          1          3          1
         4        -13          0          4          1
         5         26          1          5          1
         6        -11          0          6          1
         7         38          1          7          1
         8         -7          0          0          1
         9         -4          0          1          2
        10        -12          0          2          2
        11        112          1          3          2
        12       -123          0          4          2
        13        127          1          5          2
        14         -1          0          6          2
        15         17          1          7          2
        16        -77          0          0          2

16 rows selected. 


*/