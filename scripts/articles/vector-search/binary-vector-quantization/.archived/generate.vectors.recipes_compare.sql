prompt create embeddings using ALL_MINILM_L12_V2, MXBAI_EMBED_XSMALL_V1 and MXBAI_EMBED_LARGE_V1

set serveroutput on;
declare
    l_start timestamp := localtimestamp;
    l_model varchar2(100);
    c_divider_line constant varchar2(80) := lpad('-',80,'-');
begin

    dbms_output.put_line(c_divider_line);
    dbms_output.put_line('update recipes.embedding with ALL_MINILM_L12_V2 embeddings');
    l_start := localtimestamp;
    update recipes_compare
    set 
        embedding = vector_embedding(ALL_MINILM_L12_V2 using doc as data),
        embedding_model = 'ALL_MINILM_L12_V2';
        
    select 
        embedding_model || ' ('
        || vector_dimension_count(embedding) || ' dimensions, '
        || vector_dimension_format(embedding) || ') '
    into l_model
    from recipes_compare
    where rownum = 1;    
    
    dbms_output.put_line('Created embeddings using ' || l_model || ' total duration: ' || to_char(localtimestamp - l_start));

    dbms_output.put_line(c_divider_line);
    dbms_output.put_line('update recipes.embedding1 with MXBAI_EMBED_XSMALL_V1 embeddings');
    l_start := localtimestamp;
    update recipes_compare
    set 
        embedding1 = vector_embedding(MXBAI_EMBED_XSMALL_V1 using doc as data),
        embedding1_model = 'MXBAI_EMBED_XSMALL_V1';
    
    select 
        embedding1_model || ' ('
        || vector_dimension_count(embedding1) || ' dimensions, '
        || vector_dimension_format(embedding1) || ') '
    into l_model
    from recipes_compare
    where rownum = 1;
    
    dbms_output.put_line('Created embeddings using ' || l_model || ' total duration: ' || to_char(localtimestamp - l_start));
    
    dbms_output.put_line(c_divider_line);
    dbms_output.put_line('update recipes.embedding2 with MXBAI_EMBED_LARGE_V1 embeddings');
    l_start := localtimestamp;

    update recipes_compare
    set 
        embedding2 = vector_embedding(MXBAI_EMBED_LARGE_V1 using doc as data),
        embedding2_model = 'MXBAI_EMBED_LARGE_V1';
        
    commit;
    
    select 
        embedding2_model || ' ('
        || vector_dimension_count(embedding2) || ' dimensions, '
        || vector_dimension_format(embedding2) || ') '
    into l_model
    from recipes_compare
    where rownum = 1;
    
    dbms_output.put_line('Created embeddings using ' || l_model || ' total duration: ' || to_char(localtimestamp - l_start));
    
    commit;
    
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);    
end;
/

/* SCRIPT OUTPUT

create embeddings using ALL_MINILM_L12_V2, MXBAI_EMBED_XSMALL_V1 and MXBAI_EMBED_LARGE_V1
--------------------------------------------------------------------------------
update recipes.embedding with ALL_MINILM_L12_V2 embeddings
Created embeddings using ALL_MINILM_L12_V2 (384 dimensions, FLOAT32)  total duration: +000000000 00:00:00.511789000
--------------------------------------------------------------------------------
update recipes.embedding1 with MXBAI_EMBED_XSMALL_V1 embeddings
Created embeddings using MXBAI_EMBED_XSMALL_V1 (384 dimensions, FLOAT32)  total duration: +000000000 00:00:00.164117000
--------------------------------------------------------------------------------
update recipes.embedding2 with MXBAI_EMBED_LARGE_V1 embeddings
Created embeddings using MXBAI_EMBED_LARGE_V1 (1024 dimensions, FLOAT32)  total duration: +000000000 00:00:03.446687000


PL/SQL procedure successfully completed.


*/