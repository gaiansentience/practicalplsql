--reranking_search.binary_and_float.same_model.mxbai_xsmall.sql

prompt run the initial search by binary vectors for top 20 hits
prompt use mxbai_xsmall and jaccard metric
prompt then rerank the binary search results with search on float32 vector
prompt use mxbai_xsmall float vectors and manhattan metric

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
                select i.item_name, i.item_description, v.embedding
                from 
                    menu_items i
                    join menu_vectors v on i.item_id = v.item_id
                order by 
                    vector_distance(
                        v.embedding_binary
                        , v_binary
                        , jaccard)
                fetch first 20 rows only
                )
            )
        order by
            vector_distance(
                embedding
                , v_float
                , manhattan)
        fetch first 5 rows only);
begin
    l_search_text := 'A really sweet and decadent dessert.';
    l_start := localtimestamp;
    --Generate search vectors
    select vector_embedding(MXBAI_EMBED_XSMALL_V1 using l_search_text as data)
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
    dbms_output.put_line('Compare to search using only mxbai xsmall:');
    search_compare_menu_vectors(l_search_text, 5, 'manhattan', 'embedding', p_use_binary => false);           

end;
/

/*
run the initial search by binary vectors for top 20 hits
use mxbai_xsmall and jaccard metric
then rerank the binary search results with search on float32 vector
use mxbai_xsmall float vectors and manhattan metric
Time to generate search vectors: +000000000 00:00:00.055314000
Rank (Float 1, Binary 1 ) Turtle Cheesecake
Rank (Float 2, Binary 2 ) Molten Lava Cake
Rank (Float 3, Binary 7 ) Crème Brûlée
Rank (Float 4, Binary 6 ) Hot Chocolate
Rank (Float 5, Binary 3 ) Clafoutis
Nested Reranking Search Duration: +000000000 00:00:00.004549000
--------------------------------------------------
Compare to search using only mxbai xsmall:
Semantic search for [A really sweet and decadent dessert.] top k=5
Model MXBAI_EMBED_XSMALL_V1, metric manhattan
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.005218000
Time to run search: +000000000 00:00:00.008192000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
Hot Chocolate
Clafoutis
--------------------------------------------------


PL/SQL procedure successfully completed.


*/
