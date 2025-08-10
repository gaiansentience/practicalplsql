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
        , mod(j.dim#, 8) as bit#
        , ceil(j.dim#/8) as byte#
        , case when j.dim_val > 0 then 1 else 0 end as bit_val
    from 
        recipes g,
        json_table(
            json(vector_serialize(g.embedding returning clob)), '$[*]'
            columns (
                dim# for ordinality,
                dim_val number path '$'
            )
        ) j
), u8bytes as (
    select 
        id
        , byte#
        , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
    from 
    base
    pivot (
        max(bit_val) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        )
), vector_source as (
    select 
        id
        , json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2) as vector_string
    from u8bytes
    group by id
)
select id, to_vector(vector_string, *, binary) as vec
from vector_source
/


--covert into a subquery expression using inline views
select g.id
    --, g.embedding
    , (
    
        select to_vector(vector_source.vector_string, *, binary) as vec
        from (    
            select
                json_serialize(json_arrayagg(u8bytes.byte_val order by u8bytes.byte#) returning clob value) as vector_string
            from (
                select 
                    byte#
                    , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
                from (
                    select 
                        mod(j.dim#, 8) as bit#
                        , ceil(j.dim#/8) as byte#
                        , case when j.dim_val > 0 then 1 else 0 end as bit_val
                    from 
                        json_table(
                            json(vector_serialize(g.embedding returning clob)), '$[*]'
                            columns (dim# for ordinality, dim_val number path '$')
                        ) j
                    ) base
                    pivot (
                        max(bit_val) for bit# in (
                            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                        )
                ) u8bytes
            ) vector_source
    
    ) as binary_embedding

from recipes g
where id = 1
/

--covert into a subquery expression using inline views
--combine nested inline views where possible
select g.id
    --, g.embedding
    , (
     
            select
                to_vector(
                    json_serialize(
                        json_arrayagg(u8.byte_val order by u8.byte# returning json) 
                        returning clob value)
                    , *, binary) as vec
            from (
                select 
                    p.byte#
                    , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as byte_val
                from (
                    select 
                        mod(j.dim#, 8) as bit#
                        , ceil(j.dim#/8) as byte#
                        , case when j.dim_val > 0 then 1 else 0 end as bit_val
                    from 
                        json_table(
                            json(vector_serialize(g.embedding returning clob))
                            , '$[*]'
                            columns (dim# for ordinality, dim_val number path '$')
                        ) j
                    ) b
                    pivot (
                        max(b.bit_val) for bit# in (
                            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
                            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                    ) p
                ) u8
    
    ) as binary_embedding

from recipes g
where id = 1
/

create or replace function to_binary_vector(v in vector) return varchar2 sql_macro(scalar)
is
    l_sql varchar2(32000);
begin

    l_sql := q'~
    
        select
            to_vector(
                json_serialize(
                    json_arrayagg(u8.byte_val order by u8.byte# returning json) 
                    returning clob value)
                , *, binary) as vec
        from (
            select 
                p.byte#
                , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as byte_val
            from (
                select 
                    mod(j.dim#, 8) as bit#
                    , ceil(j.dim#/8) as byte#
                    , case when j.dim_val > 0 then 1 else 0 end as bit_val
                from 
                    json_table(
                        json(vector_serialize(v returning clob))
                        , '$[*]'
                        columns (dim# for ordinality, dim_val number path '$')
                    ) j
                ) b
                pivot (
                    max(b.bit_val) for bit# in (
                        1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
                        , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                ) p
            ) u8
    
    
    ~';
    
    return l_sql;

end to_binary_vector;
/


select g.embedding, to_binary_vector(g.embedding) as binary_embedding
from recipes g