--reranking_search.binary_and_float.mixed_models.sql

prompt run the initial search by binary vectors for top 20 hits
prompt use the mxbai_xsmall binary vectors in menu_vectors.embedding_binary
prompt then rerank the binary search results with search on float32 vectors
prompt use the miniLM_12 float vectors in menu_vectors.embedding3

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
                select i.item_name, i.item_description, v.embedding3 as embedding
                from 
                    menu_items i
                    join menu_vectors v on i.item_id = v.item_id
                order by 
                    vector_distance(
                        v.embedding_binary
                        , v_binary
                        , hamming)
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
    dbms_output.put_line('Generate final search vector using ALL_MINILM_L12_V2');
    
    select vector_embedding(ALL_MINILM_L12_V2 using l_search_text as data)
    into v_float;
    
    dbms_output.put_line('Generate binary search vector using MXBAI_EMBED_XSMALL_V1');
    select 
        to_binary_vector(
                vector_embedding(MXBAI_EMBED_XSMALL_V1 using l_search_text as data))
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
    dbms_output.put_line('Compare to search using only MiniLM12:');
    search_compare_menu_vectors(l_search_text, 5, 'cosine', 'embedding3', p_use_binary => false);
    

end;
/

/*
run the initial search by binary vectors for top 20 hits
use the mxbai_xsmall binary vectors in menu_vectors.embedding_binary
then rerank the binary search results with search on float32 vectors
use the miniLM_12 float vectors in menu_vectors.embedding3
Generate final search vector using ALL_MINILM_L12_V2
Generate binary search vector using MXBAI_EMBED_XSMALL_V1
Time to generate search vectors: +000000000 00:00:00.505665000
Rank (Float 1, Binary 19) Tofu and Lentil Shepherd's Pie
Rank (Float 2, Binary 4 ) Quinoa Salad
Rank (Float 3, Binary 1 ) Tofu and Kale Power Bowl
Rank (Float 4, Binary 6 ) Tofu Buddha Bowl
Rank (Float 5, Binary 7 ) Seitan and Spinach Lasagna
Nested Reranking Search Duration: +000000000 00:00:00.002750000
--------------------------------------------------
Compare to search using only MiniLM12:
Semantic search for [A healthy and nutritious dinner.] top k=5
Model ALL_MINILM_L12_V2, metric cosine
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.106604000
Time to run search: +000000000 00:00:00.110360000
Tofu and Lentil Shepherd's Pie
Tofu and Peanut Noodles
Chicken Caesar Wrap
Quinoa Salad
Tofu and Kale Power Bowl
--------------------------------------------------


PL/SQL procedure successfully completed.


*/