--2.01.01.quantize-vector.sql

--a vector is the same shape as a json array
select 
    1 as id
    , to_vector(
        '[-22,-44,33,-13,26,-11,38,-7]'
        , 8, int8
        ) as vec
/



select
    json[-22,-44,33,-13,26,-11,38,-7] as jvec
/