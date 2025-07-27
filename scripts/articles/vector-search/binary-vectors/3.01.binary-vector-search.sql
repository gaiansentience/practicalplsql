

select rownum as ranking, name, doc
from
(
select name, doc, to_binary_vector(g.embedding) as bvec
from recipes g
order by 
    vector_distance(
        bvec
--        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        , jaccard)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    JACCARD_DISTANCE(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        )
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        , hamming)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    HAMMING_DISTANCE(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        )
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , euclidean)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , dot)
fetch first 3 rows only
)
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
update menu_items i set i.binary_embedding = to_binary_vector(i.embedding);

commit;

select embedding, from_vector(binary_embedding) as binary_embedding_serialized from menu_items;

alter table recipes add binary_embedding vector(*,binary);

select * from recipes;

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
