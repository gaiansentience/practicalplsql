--title_code_sample.sql
set serveroutput on;
declare
    l_search_text varchar2(100);
    l_search_float  vector(*, float32);
    l_search_binary vector(*, binary);
    l_results sys.odcivarchar2list;
begin
    l_search_text := 'A wickedly delectable, delicious and decadent dessert.';

    select
        vector_embedding(
            ALL_MINILM_L12_V2 
            using l_search_text as data)
        , to_binary_vector(
            vector_embedding(
                MXBAI_EMBED_LARGE_V1 
                using l_search_text as data)
            )
        into l_search_float, l_search_binary;

    with fast_binary_search as (
        select 
            i.item_name
            , v.embedding3 as embedding_float
        from 
            menu_items i
            join menu_vectors v on i.item_id = v.item_id
        order by 
            vector_distance(
                v.embedding1_binary
                , l_search_binary
                , hamming)
        fetch first 25 rows only   
    ), precise_float_search as (
        select item_name
        from fast_binary_search b
        order by 
            vector_distance(
                b.embedding_float
                , l_search_float
                , cosine)
        fetch first 5 rows only
    )
    select item_name
    bulk collect into l_results
    from precise_float_search;
    
    for v in values of l_results loop
        dbms_output.put_line(v);
    end loop;

end;
/

/*

Turtle Cheesecake
Chocolate Soufflé
Chocolate Mousse
Peach Cobbler
Molten Lava Cake

*/


