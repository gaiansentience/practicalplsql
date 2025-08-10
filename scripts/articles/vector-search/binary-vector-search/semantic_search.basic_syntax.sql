--semantic_search.basic_syntax.sql
--current embeddings loaded should use embedding model MXBAI_EMBED_XSMALL_V1

column name format a20

select name
from recipe_vectors
order by 
    vector_distance(
        embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'tasty dessert' as data)
        , cosine)
fetch first 3 rows only
/


/*

NAME                
--------------------
Strawberry Pie
Chocolate Cake
Raspberry Tarts

*/