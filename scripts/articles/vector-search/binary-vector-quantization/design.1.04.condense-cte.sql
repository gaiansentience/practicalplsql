--design.1.04.condense-cte.sql

prompt combine the jbase CTE with the final select statement to condense the sql
with base as (
    select 
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
)
select jt.dim#, jt.dimval
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
combine the jbase CTE with the final select statement to condense the sql

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