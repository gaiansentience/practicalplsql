select r.id, r.name
, r.doc, r.embedding
, vector_dimension_count(r.embedding) as dim_cnt, vector_dimension_format(r.embedding) as dim_val_fmt
, to_vector(r.embedding, *, int8) as int8_vector
from recipes r
/

--convert to binary vectors
with base as (
select r.id, json(from_vector(r.embedding returning clob)) as jvec
from recipes r 
--where r.id = 1
), extract_dim_val as (
select b.id, j.dim_val, j.dim_num
from base b,
json_table(b.jvec, '$[*]' columns (dim_num for ordinality ,dim_val number path '$')) j
), show_bytes as (
select  id, ceil( dim_num/8 ) as dim_byte, case when mod(dim_num,8) = 0 then 8 else mod(dim_num,8) end  as bit_num--, dim_num, dim_val
, case sign(dim_val) when 1 then 1 else 0 end as bit_val
from extract_dim_val
), convert_bytes as (
select id, dim_byte, bin_to_num("1","2","3","4","5","6","7","8") as byte_to_uint8
from show_bytes
pivot(
    max(bit_val) for bit_num in (1,2,3,4,5,6,7,8)
)
)
select id, to_vector(raw_vec,384,binary) as bin_vec
from 
(
select id, json_arrayagg(byte_to_uint8 order by dim_byte returning clob) as raw_vec
from convert_bytes
group by id
)
/