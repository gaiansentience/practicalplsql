--search.compare_binary.recipe_vectors.sql
--recipe_vectors embeddings should be created with mx_bai_embed_large_v1 
--binary_embeddings should be updated with to_binary_vector
set serveroutput on;

declare
    l_search_text varchar2(100) := 'a decadent dessert would be tasty';
begin
    search_compare_recipe_vectors(l_search_text, 3, 'cosine', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'euclidean', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'manhattan', p_use_binary => false);
    search_compare_recipe_vectors(l_search_text, 3, 'hamming', p_use_binary => true);
    search_compare_recipe_vectors(l_search_text, 3, 'jaccard', p_use_binary => true);    
end;
/





