--search.compare_binary.recipe_vectors.sql
--recipe_vectors embeddings should be created with mx_bai_embed_large_v1 
--binary_embeddings should be updated with to_binary_vector
set serveroutput on;

declare
    l_search_text varchar2(100) := 'a decadent dessert would be tasty';
    type t_strings is table of varchar2(100);
    l_columns t_strings := t_strings('embedding', 'embedding1', 'embedding2', 'embedding3');
    l_metrics t_strings := t_strings('cosine','euclidean','manhattan');
begin
    <<models>>
    for c in values of l_columns loop
        <<float_metrics>>
        for m in values of l_metrics loop
            search_compare_menu_vectors(l_search_text, 3, m, c, p_use_binary => false);
        end loop float_metrics;
        search_compare_menu_vectors(l_search_text, 3, 'hamming', c, p_use_binary => true);
        search_compare_menu_vectors(l_search_text, 3, 'jaccard', c, p_use_binary => true);    
    end loop models;
    
end;
/


declare
    l_search vector;
    l_search_binary vector;
    l_start timestamp;
begin
    select vector_embedding(MXBAI_EMBED_LARGE_V1 using 'comfort food' as data)
    into l_search;
    
    dbms_output.put_line('Semantic search with float32 vectors - cosine distance');   
    l_start := localtimestamp;
    for r in (
        select name
        from recipe_vectors
        order by 
            vector_distance(embedding, l_search, cosine)
        fetch first 3 rows only
    ) loop
        dbms_output.put_line(r.name);
    end loop;
    dbms_output.put_line(to_char(localtimestamp - l_start));    
    
    select to_binary_vector(l_search) into l_search_binary;
    
    dbms_output.put_line('Semantic search with binary vectors - hamming distance');  
    l_start := localtimestamp;
    for r in (
        select name
        from recipe_vectors
        order by 
            vector_distance(embedding_binary, l_search_binary, hamming)
        fetch first 3 rows only
    ) loop
        dbms_output.put_line(r.name);
    end loop;
    dbms_output.put_line(to_char(localtimestamp - l_start));       
    
    
end;
/

