--create.procedure.compare_binary_search.recipe_vectors.sql

prompt create a procedure to test different model searches between float32 and binary

create or replace procedure compare_binary_search_recipe_vectors(
    p_search_term in varchar2, p_model in varchar2
--recipe_vectors embeddings should be created with mx_bai_embed_large_v1 
--binary_embeddings should be updated with to_binary_vector
set serveroutput on;
declare
    l_search vector;
    l_search_binary vector;
    l_start timestamp;
begin
    select vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
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



select name, doc, embedding_model
from recipe_vectors g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
        , cosine)
fetch first 3 rows only
/

select name, doc, embedding_model
from recipe_vectors g
order by 
    vector_distance(
        g.embedding_binary
        , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
        , hamming)
fetch first 3 rows only
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            to_binary_vector(g.embedding)
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            , hamming)
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        HAMMING_DISTANCE(
            to_binary_vector(g.embedding)
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            )
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , euclidean)
    fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , dot)
    fetch first 3 rows only
)
/



select rownum as ranking, name, doc
from
(
    select name, doc
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding
            , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
            , cosine)
    fetch first 5 rows only
)
/

select rownum as ranking, name, doc, embedding_model
from
(
    select name, doc, embedding_model
    from recipe_vectors g
    order by 
        vector_distance(
            g.embedding_binary
            , to_binary_vector(vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data))
            , hamming)
    fetch first 5 rows only
)
/

with base as (
select mi.item_name, mi.item_description, mv.embedding as vfloat, mv.embedding_binary as vbinary
from menu_items mi
    join menu_vectors mv using (item_id)
)
select item_name
    ,vector_distance(vfloat, vector_embedding(mxbai_embed_xsmall_v1 using 'traditional dinner' as data), cosine) as vdist
from base
order by vdist
fetch first 10 rows only
/

with base as (
select mi.item_name, mi.item_description, mv.embedding as vfloat, mv.embedding_binary as vbinary
from menu_items mi
    join menu_vectors mv using (item_id)
)
select item_name
    ,vector_distance(vbinary, to_binary_vector(vector_embedding(mxbai_embed_xsmall_v1 using 'traditional dinner' as data)), jaccard) as vdist
from base
order by vdist
fetch first 10 rows only
/