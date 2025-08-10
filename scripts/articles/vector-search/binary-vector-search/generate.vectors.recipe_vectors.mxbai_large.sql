--generate.vectors.recipe_vectors.mxbai_large.sql

prompt update recipe_vectors.embeddings using MXBAI_EMBED_LARGE_V1

set serveroutput on;
declare
    l_start timestamp := localtimestamp;
    l_model varchar2(100);
begin

    update recipe_vectors
    set 
        embedding = vector_embedding(MXBAI_EMBED_LARGE_V1 using doc as data),
        embedding_model = 'MXBAI_EMBED_LARGE_V1';
        
    commit;
    
    select  
        embedding_model || ' ('
        || vector_dimension_count(embedding) || ' dimensions, '
        || vector_dimension_format(embedding) || ') '
    into l_model
    from recipe_vectors
    where rownum = 1;
    
    dbms_output.put_line('Created embeddings using ' || l_model);
    dbms_output.put_line('Total Duration: ' || to_char(localtimestamp - l_start));
    
end;
/

/* SCRIPT OUTPUT:

update recipe_vectors.embeddings using MXBAI_EMBED_LARGE_V1
Created embeddings using MXBAI_EMBED_LARGE_V1 (1024 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:03.610967000

*/