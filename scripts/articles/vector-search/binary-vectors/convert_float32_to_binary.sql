select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
        , cosine)
fetch first 3 rows only
)
/

select * from recipes;

with base as (
select 
    g.id
    --, g.name
    --, g.embedding
    --, j.dim#
    --, j.dim_val
    , case mod(j.dim#,8) when 0 then 8 else mod(j.dim#,8) end as bit#
    , ceil(j.dim#/8) as byte#
    , case when j.dim_val > 0 then 1 else 0 end as bit_val
from recipes g,
json_table(json(vector_serialize(g.embedding returning clob)), '$[*]'
columns (
    dim# for ordinality,
    dim_val number path '$'
)
) j
), u8bytes as (
select id, byte#, bin_to_num(b#8, b#7, b#6, b#5, b#4, b#3, b#2, b#1) as byte_val
from base
pivot (max(bit_val) for bit# in (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 8 as b#8))
order by id, byte#
), vector_source as (
select id, count(*) * 8 as dims,json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2) as vector_string
from u8bytes
group by id
)
select id, to_vector(vector_string, 1024, binary) as vec
from vector_source
/



select bin_to_num(1,1,1,1,1,1,1,1)
/