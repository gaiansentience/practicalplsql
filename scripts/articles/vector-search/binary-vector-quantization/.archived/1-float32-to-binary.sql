
--a vector is the same shape as a json array
select 
    1 as id
    , to_vector(
        '[-22,-44,33,-13,26,-11,38,-7]'
        , 8, int8
        ) as vec
/

--serialize the vector as text and use with json constructor
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
    , json(
        vector_serialize(b.vec returning clob)
        ) as jvec
from base b
/

--use json_table to separate the array into its dimensions, with one dimension per row
with base as (
    select 
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            ) as vec
), jbase as (
    select
        b.id
        , json(
            vector_serialize(b.vec returning clob)
            ) as jvec
    from base b
)
select b.id, jt.dim#, jt.dimval
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

--combine the jbase CTE with the final select to condense the sql
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

--quantize the array elements
--identify groups (bytes) of 8 dimensions (bits) to pack into uint8 values
--using mod(dim#,8) shows the 8th dimension as bit#0
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


--use 16 dimensions to confirm that bytes are correctly identified
with base as (
    select
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
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

--prepare to pivot the bit values fro quantized_base, 
--remove dim# and dimval columns to prevent unecessary grouping levels in the pivot
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
/

--pivot the bit values so that each byte has 8 bits
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
    p.id, p.byte#, p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8
from quantized_base q
pivot(
    max(q.dim_bitval) for bit# in (
        1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
        , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
    ) p
/


--use bin_to_num function in the pivot expression to convert pivoted bits to uint8 bytes
with base as (
    select
        1 as id
        , to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , 16, int8) as vec
), quantized_base as (
    select 
        b.id
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
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
)
select
    id
    , byte#
    , uint_byte
from pivot_to_bytes
/



--use json_arrayagg to combine the bytes into an array
--serialize this as textual input for the binary vector
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
), pivot_to_bytes as (
    select
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
)
select 
    id
    , json_serialize(
        json_arrayagg(uint_byte order by byte#) 
        returning clob) as textual_input
from pivot_to_bytes
group by id
/

--construct a binary vector using the serialized json array
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
), pivot_to_bytes as (
    select
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
)
select 
    pb.id
    , to_vector(
        json_serialize(
            json_arrayagg(pb.uint_byte order by pb.byte#) 
            returning clob)
        , *, binary) as binary_vector
from pivot_to_bytes pb
group by pb.id
/

    

--substitute the recipes table for the literal test vectors
--result quantizes each float32 vector to binary dimension format
with base as (
    select
        r.id
        , r.embedding as vec
    from recipes r
), quantized_base as (
    select 
        b.id
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
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
)
select 
    pb.id
    , to_vector(
        json_serialize(
            json_arrayagg(pb.uint_byte order by pb.byte#) 
            returning clob)
        , *, binary) as binary_vector
from pivot_to_bytes pb
group by pb.id
/

--turn the CTE query inside out so that it only uses inline views except for the base expression
with base as (
    select
        r.id
        , r.embedding as vec
    from recipes r
)
select 
    pb.id
    , to_vector(
        json_serialize(
        json_arrayagg(pb.uint_byte order by pb.byte#) 
        returning clob)
        , *, binary) as my_binary_vector
from 
    (
    select
        p.id
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from 
        (
        select 
            b.id
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
        ) q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
    ) pb
group by pb.id
/


---convert everything to a correlated subquery 
--remove the id column from the subquery inline views
--remove the reference to base CTE in the json_table source and use the r.embedding vector value
with base as (
    select
        r.id
        , r.embedding as vec
    from recipes r
)
select 
    r.id
    , (

        select 
            to_vector(
                json_serialize(
                    json_arrayagg(pb.uint_byte order by pb.byte#) 
                    returning clob)
                , *, binary)
        from 
            (
            select
                p.byte#
                , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
            from 
                (
                select 
                    case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
                    , mod(jt.dim#, 8) as bit#
                    , ceil(jt.dim#/8) as byte#
                from 
                    json_table (
                        json(vector_serialize(r.embedding returning clob))
                        , '$[*]'
                        columns(
                            dim# for ordinality
                            , dimval number path '$'
                            )
                        ) jt
                ) q
            pivot(
                max(q.dim_bitval) for bit# in (
                    1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
                    , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                ) p
            ) pb

    ) as binary_vector
from recipes r
/

---create a scalar macro from the subquery, passing the vector as a paramter
create or replace function to_binary_vector(
    p_input_vector in vector
    ) return varchar2
    sql_macro (scalar)
is
begin

    return q'~
    
        select 
            to_vector(
                json_serialize(
                    json_arrayagg(pb.uint_byte order by pb.byte#) 
                    returning clob)
                , *, binary)
        from 
            (
            select
                p.byte#
                , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
            from 
                (
                select 
                    case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
                    , mod(jt.dim#, 8) as bit#
                    , ceil(jt.dim#/8) as byte#
                from 
                    json_table (
                        json(vector_serialize(p_input_vector returning clob))
                        , '$[*]'
                        columns(
                            dim# for ordinality
                            , dimval number path '$'
                            )
                        ) jt
                ) q
            pivot(
                max(q.dim_bitval) for bit# in (
                    1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
                    , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                ) p
            ) pb 
    
    ~';
end to_binary_vector;
/

--check with binary for 42:
select 
    to_binary_vector(
        to_vector('[0,0,1,0,1,0,1,0]',*, int8) 
        ) as binary_vector
/

--check with the test vector that should return [42, 42]
with base as (
    select
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7, -4,-12,112,-123,127,-1,17,-77]'
            , *, int8) as vec
)
select 
    to_binary_vector(b.vec) as my_binary_vector
from base b
/

--try it with the recipes table
select 
    r.id
    , r.name
    , to_binary_vector(r.embedding) as binary_embedding
from recipes r
order by r.name
/




select * from recipes;

describe recipes;

select g.embedding, to_binary_vector(g.embedding) as binary_embedding
from recipes g
/

--quantize the vectors for faster search
update recipes g
set g.embedding_q = to_binary_vector(g.embedding)
/

select vector_dims(embedding) as v_dims, vector_dimension_Format(embedding) as v_fmt, vector_dims(binary_v) as b_dims, vector_dimension_format(binary_v) as b_fmt
from (
select g.embedding, to_binary_vector(g.embedding) as binary_v 
from recipes g
);

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , cosine)
fetch first 5 rows only
)
/

select count(*) from menu_items;

describe menu_items;


update menu_items set embedding = vector_embedding(MXBAI_EMBED_XSMALL_V1 using item_description as data);

commit;

select i.embedding, to_binary_vector(i.embedding) as bv from menu_items i;

--vector is inserted as 'INVALID VECTOR ENCODING'
update menu_items i set i.quantized_embedding = to_binary_vector(i.embedding);

commit;

select embedding, quantized_embedding from menu_items;

alter table recipes add binary_embedding vector(*,binary);

select embedding from recipes;

update recipes set binary_embedding = to_binary_vector(embedding);

select binary_embedding from recipes;

describe menu_items;

alter table menu_items add binary_embedding vector(*, binary);
--correct vectors are in table
update menu_items set binary_embedding = to_binary_vector(embedding);

commit;

select * from menu_items;

describe recipes;



select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding_q
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        , cosine)
fetch first 5 rows only
)
/
select rownum as float32_vector_ranking, binary_vector_ranking,item_name, item_description
from
(
select binary_vector_ranking, item_name, item_description
from
    (
    select rownum as binary_vector_ranking, item_name, item_description, embedding
    from
        (
        select item_name, item_description, embedding
        from menu_items g
        order by 
            vector_distance(
                g.binary_embedding
                , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
                , jaccard)
        fetch first 25 rows only
        )
    )
order by
    vector_distance(embedding, vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data),cosine)
fetch first 5 rows only
)
/