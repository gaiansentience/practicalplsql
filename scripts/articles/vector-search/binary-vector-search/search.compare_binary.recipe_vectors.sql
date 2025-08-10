--search.compare_binary.recipe_vectors.sql
--recipe_vectors embeddings should be created with MXBAI_EMBED_XSMALL_V1 
@generate.vectors.recipe_vectors.mxbai_xsmall.sql
--binary_embeddings should be updated with to_binary_vector
@quantize_vectors.recipe_vectors.sql

set serveroutput on;

declare
    l_search_text varchar2(100);
begin
    l_search_text := 'a deliciously decadent dessert sounds good';
    search_compare_recipe_vectors(l_search_text, 3, 'cosine', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'euclidean', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'manhattan', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'hamming', p_use_binary => true);
    search_compare_recipe_vectors(l_search_text, 3, 'jaccard', p_use_binary => true);    
end;
/



/*
update recipe_vectors.embeddings using MXBAI_EMBED_XSMALL_V1
Created embeddings using MXBAI_EMBED_XSMALL_V1 (384 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:00.197572000


PL/SQL procedure successfully completed.

use the macro to quantize the vectors in the recipe vectors table
Converted 15 vectors to binary format


PL/SQL procedure successfully completed.

Elapsed: 00:00:00.018
Semantic search for [a deliciously decadent dessert sounds good] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric cosine
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004650000
Time to run search: +000000000 00:00:00.000291000
Strawberry Pie
Raspberry Tarts
Chocolate Cake
--------------------------------------------------
Semantic search for [a deliciously decadent dessert sounds good] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric euclidean
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004952000
Time to run search: +000000000 00:00:00.000143000
Strawberry Pie
Raspberry Tarts
Chocolate Cake
--------------------------------------------------
Semantic search for [a deliciously decadent dessert sounds good] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric manhattan
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004621000
Time to run search: +000000000 00:00:00.000186000
Strawberry Pie
Raspberry Tarts
Chocolate Cake
--------------------------------------------------
Semantic search for [a deliciously decadent dessert sounds good] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric hamming
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.005079000
Time to run search: +000000000 00:00:00.000111000
Strawberry Pie
Raspberry Tarts
Chocolate Cake
--------------------------------------------------
Semantic search for [a deliciously decadent dessert sounds good] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric jaccard
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.004912000
Time to run search: +000000000 00:00:00.000130000
Strawberry Pie
Raspberry Tarts
Chocolate Cake
--------------------------------------------------


PL/SQL procedure successfully completed.


*/

