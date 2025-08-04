--generate.vectors.recipe_vectors.all_miniLM_L6.sql

prompt update recipe_vectors.embeddings using ALL_MINILM_L6_V2

set serveroutput on;
declare
    l_start timestamp := localtimestamp;
    l_model varchar2(100);
begin

    update recipe_vectors
    set 
        embedding = vector_embedding(ALL_MINILM_L6_V2 using doc as data),
        embedding_model = 'ALL_MINILM_L6_V2';
        
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

update recipe_vectors.embeddings using ALL_MINILM_L6_V2
Created embeddings using ALL_MINILM_L6_V2 (384 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:00.203806000

*/