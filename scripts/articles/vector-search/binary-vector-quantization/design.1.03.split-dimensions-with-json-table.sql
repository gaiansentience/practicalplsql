--design.1.3-split-dimensions-with-json-table.sql


prompt use json_table to separate the array into its elements
prompt use the array ordinality to label the dimensions
prompt each row is now the value of one dimension from the input vector
with base as (
    select 
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
), jbase as (
    select
        json(
            vector_serialize(b.vec returning clob)
            ) as jvec
    from base b
)
select jt.dim#, jt.dimval
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


/*

use json_table to separate the array into its elements
use the array ordinality to label the dimensions
each row is now the value of one dimension from the input vector

      DIM#     DIMVAL
---------- ----------
         1        -22
         2        -44
         3         33
         4        -13
         5         26
         6        -11
         7         38
         8         -7

8 rows selected. 

*/