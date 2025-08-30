


select name, doc, embedding_model
from recipe_vectors g
order by 
    vector_distance(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
        , jaccard)
fetch first 3 rows only
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        JACCARD_DISTANCE(
            to_binary_vector(g.embedding)
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            )
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            to_binary_vector(g.embedding)
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            , hamming)
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        HAMMING_DISTANCE(
            to_binary_vector(g.embedding)
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            )
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , euclidean)
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , dot)
    fetch first 3 rows only
)
/



select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , cosine)
    fetch first 5 rows only
)
/

select rownum as ranking, name, doc, embedding_model
from
(
    select name, doc, embedding_model
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding_binary
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            , hamming)
    fetch first 5 rows only
)
/

with base as (
select mi.item_name, mi.item_description, mv.embedding as vfloat, mv.embedding_binary as vbinary
from menu_items mi
    join menu_vectors mv using (item_id)
)
select item_name
    ,vector_distance(vfloat, vector_embedding(mxbai_embed_xsmall_v1 using 'traditional dinner' as data), cosine) as vdist
from base
order by vdist
fetch first 10 rows only
/

with base as (
select mi.item_name, mi.item_description, mv.embedding as vfloat, mv.embedding_binary as vbinary
from menu_items mi
    join menu_vectors mv using (item_id)
)
select item_name
    ,vector_distance(vbinary, to_binary_vector(vector_embedding(mxbai_embed_xsmall_v1 using 'traditional dinner' as data)), jaccard) as vdist
from base
order by vdist
fetch first 10 rows only
/