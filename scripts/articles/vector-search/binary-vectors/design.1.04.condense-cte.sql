--design.1.04.condense-cte.sql

prompt add an id field to the source vector row
prompt combine the jbase CTE with the final select statement to condense the sql
with base as (
    select 
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
)
select b.id, jt.dim#, jt.dimval
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
add an id field to the source vector row
combine the jbase CTE with the final select statement to condense the sql

        ID       DIM#     DIMVAL
---------- ---------- ----------
         1          1        -22
         1          2        -44
         1          3         33
         1          4        -13
         1          5         26
         1          6        -11
         1          7         38
         1          8         -7

8 rows selected. 
*/