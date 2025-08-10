--reranking_search.basic_syntax.sql

column item_name format a30

prompt run initial search by binary vectors for top 25 hits with an inline view
prompt then rerank the binary search results with search on float32 vector

select rownum as float_rank, binary_rank, item_name
from
    (
    select binary_rank, item_name
    from
        (
        select rownum as binary_rank, item_name, embedding
        from
            (
            select i.item_name, v.embedding
            from 
                menu_items i
                join menu_vectors v on i.item_id = v.item_id
            order by 
                vector_distance(
                    v.embedding_binary
                    , to_binary_vector(
                        vector_embedding(
                            MXBAI_EMBED_XSMALL_V1 
                            using 'A really sweet treat would be good.' as data))
                    , hamming)
            fetch first 25 rows only
            )
        )
    order by
        vector_distance(
            embedding 
            , vector_embedding(
                MXBAI_EMBED_XSMALL_V1 
                using 'A really sweet treat would be good.' as data)
            , manhattan)
    fetch first 5 rows only
    )
/


/*

run initial search by binary vectors for top 25 hits with an inline view
then rerank the binary search results with search on float32 vector

FLOAT_RANK BINARY_RANK ITEM_NAME                     
---------- ----------- ------------------------------
         1           1 Rocky Road                    
         2           8 Snickerdoodle                 
         3          22 Oatmeal Raisin Cookie         
         4           3 Fruit Salad                   
         5           4 Sugar Cookie    
         
*/         
