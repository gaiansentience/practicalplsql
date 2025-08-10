--design.1.12.test-with-recipe-vectors.sql

column id format 9
set long 4000 
set pagesize 0
column conversion_results format a80


prompt substitute the recipes table for the literal test vectors
prompt the result quantizes each 384 dimension float32 vector to binary dimension format
prompt vector values are wrapped in output from sqlplus
with base as (
    select
        r.name
        , r.embedding as vec
    from recipe_vectors r
), quantized_base as (
    select 
        b.name
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
        p.name
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
), converted_binary_vectors as (
    select 
        pb.name
        , to_vector(
            json_serialize(
                json_arrayagg(pb.uint_byte order by pb.byte#) 
                returning clob)
            , *, binary) as binary_vector
    from pivot_to_bytes pb
    group by pb.name
)
select
    'Recipe: ' || name || chr(10)
    || ' Converted Vector has ' || vector_dimension_count(binary_vector) || ' dimensions' || chr(10)
    || ' Converted Vector dimension format is ' || vector_dimension_format(binary_vector) || chr(10)
    || ' Serialized Vector: ' || chr(10)
    || vector_serialize(binary_vector) as conversion_results
from converted_binary_vectors
order by name
/

