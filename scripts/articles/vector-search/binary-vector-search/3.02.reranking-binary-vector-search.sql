column item_name format a30

prompt run initial search by binary vectors for top 25 hits
prompt then rerank the binary search results with search on float32 vector
select rownum as float32_vector_ranking, binary_vector_ranking,item_name
from
(
select binary_vector_ranking, item_name--, item_description
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
        fetch first 4 rows only
        )
    )
order by
    vector_distance(embedding, vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data), manhattan)
fetch first 5 rows only
)
/