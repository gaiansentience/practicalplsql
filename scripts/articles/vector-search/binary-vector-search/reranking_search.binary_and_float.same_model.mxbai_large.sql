--reranking_search.binary_and_float.same_model.mxbai_large.sql

prompt run the initial search by binary vectors for top 20 hits
prompt use the mxbai large model with hamming metric
prompt then rerank the binary search results with search on float32 vectors
prompt use the mxbai large model float vectors with cosine metric

declare
    l_start timestamp;
    l_search_text varchar2(100);
    v_float vector;
    v_binary vector;
    cursor c is
    select rownum as float_rank, binary_rank,item_name
    from
        (
        select binary_rank, item_name
        from
            (
            select rownum as binary_rank, item_name, embedding
            from
                (
                select i.item_name, i.item_description, v.embedding1 as embedding
                from 
                    menu_items i
                    join menu_vectors v on i.item_id = v.item_id
                order by 
                    vector_distance(
                        v.embedding1_binary
                        , v_binary
                        , jaccard)
                fetch first 20 rows only
                )
            )
        order by
            vector_distance(
                embedding
                , v_float
                , cosine)
        fetch first 5 rows only);
begin
    l_search_text := 'A healthy and nutritious dinner.';
    l_start := localtimestamp;
    --Generate search vectors
    select vector_embedding(MXBAI_EMBED_LARGE_V1 using l_search_text as data)
    into v_float;
    
    select to_binary_vector(v_float)
    into v_binary;
    dbms_output.put_line(
        'Time to generate search vectors: ' || to_char(localtimestamp - l_start));
    
    l_start := localtimestamp;
    
    for r in c loop   

        dbms_output.put_line(
            'Rank (Float ' || r.float_rank 
            || ', Binary ' || rpad(r.binary_rank,2,' ') 
            || ') ' || r.item_name);

    end loop;
    
    dbms_output.put_line(
        'Nested Reranking Search Duration: ' || to_char(localtimestamp - l_start));
        
    dbms_output.put_line(lpad('-',50,'-'));
    dbms_output.put_line('Compare to search using only mxbai large:');
    search_compare_menu_vectors(l_search_text, 5, 'cosine', 'embedding1', p_use_binary => false);        

end;
/

/*
run the initial search by binary vectors for top 20 hits
use the mxbai large model with hamming metric
then rerank the binary search results with search on float32 vectors
use the mxbai large model float vectors with cosine metric
Time to generate search vectors: +000000000 00:00:03.479437000
Rank (Float 1, Binary 6 ) Lentil Salad
Rank (Float 2, Binary 3 ) Tofu and Kale Power Bowl
Rank (Float 3, Binary 5 ) Quinoa Salad
Rank (Float 4, Binary 8 ) Tofu and Mango Salad
Rank (Float 5, Binary 7 ) Farro Vegetable Salad
Nested Reranking Search Duration: +000000000 00:00:00.006480000
--------------------------------------------------
Compare to search using only mxbai large:
Semantic search for [A healthy and nutritious dinner.] top k=5
Model MXBAI_EMBED_LARGE_V1, metric cosine
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:00.969254000
Time to run search: +000000000 00:00:00.978401000
Lentil Salad
Tofu and Kale Power Bowl
Tofu Buddha Bowl
Quinoa Salad
Tofu and Mango Salad
--------------------------------------------------


PL/SQL procedure successfully completed.


*/