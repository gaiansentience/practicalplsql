prompt create embeddings using both mxbai models

set serveroutput on;
declare
    l_start timestamp := localtimestamp;
    l_model varchar2(100);
begin

    update recipes
    set 
        embedding1 = vector_embedding(MXBAI_EMBED_XSMALL_V1 using doc as data),
        embedding1_model = 'MXBAI_EMBED_XSMALL_V1';
        
            
    commit;
    
    select distinct 
        embedding1_model || ' ('
        || vector_dimension_count(embedding1) || ' dimensions, '
        || vector_dimension_format(embedding1) || ') '
    into l_model
    from recipes;
    
    dbms_output.put_line('Created embeddings using ' || l_model || to_char(localtimestamp - l_start));
    
    
    l_start := localtimestamp;

    update recipes
    set 
        embedding2 = vector_embedding(MXBAI_EMBED_LARGE_V1 using doc as data),
        embedding2_model = 'MXBAI_EMBED_LARGE_V1';
        
    commit;
    
    select distinct 
        embedding2_model || ' ('
        || vector_dimension_count(embedding2) || ' dimensions, '
        || vector_dimension_format(embedding2) || ') '
    into l_model
    from recipes;
    
    dbms_output.put_line('Created embeddings using ' || l_model || to_char(localtimestamp - l_start));
    
end;
/

--PL/SQL procedure successfully completed.
--
--Created embeddings using MXBAI_EMBED_XSMALL_V1 (384 dimensions, FLOAT32) +000000000 00:00:00.219226000
--Created embeddings using MXBAI_EMBED_LARGE_V1 (1024 dimensions, FLOAT32) +000000000 00:00:22.765795000