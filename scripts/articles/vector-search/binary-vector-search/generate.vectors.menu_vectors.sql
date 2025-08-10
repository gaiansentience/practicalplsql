--generate.vectors.menu_vectors.sql

prompt create embeddings using ALL_MINILM_L12_V2, ALL_MINILM_L6_V2, MXBAI_EMBED_XSMALL_V1 and MXBAI_EMBED_LARGE_V1


set serveroutput on;
declare
    l_start timestamp;
    l_model varchar2(50);
    c_divider_line constant varchar2(80) := lpad('-', 80, '-');
begin

    dbms_output.put_line(c_divider_line);
    l_start := localtimestamp;
    l_model := 'MXBAI_EMBED_XSMALL_V1';
    
    update menu_vectors mv
    set 
        mv.embedding = vector_embedding(MXBAI_EMBED_XSMALL_V1 using mi.item_description as data)
        , mv.embedding_model = l_model
    using menu_items mi
    where mv.item_id = mi.item_id;
    dbms_output.put_line('Updated ' || sql%rowcount || ' embeddings using ' || l_model);
    dbms_output.put_line('Total duration: ' || to_char(localtimestamp - l_start));


    dbms_output.put_line(c_divider_line);
    l_start := localtimestamp;
    l_model := 'MXBAI_EMBED_LARGE_V1';
    
    update menu_vectors mv
    set 
        mv.embedding1 = vector_embedding(MXBAI_EMBED_LARGE_V1 using mi.item_description as data)
        , mv.embedding1_model = l_model
    using menu_items mi
    where mv.item_id = mi.item_id;
    dbms_output.put_line('Updated ' || sql%rowcount || ' embeddings using ' || l_model);
    dbms_output.put_line('Total duration: ' || to_char(localtimestamp - l_start));
    
    dbms_output.put_line(c_divider_line);
    l_start := localtimestamp;
    l_model := 'ALL_MINILM_L6_V2';
    
    update menu_vectors mv
    set 
        mv.embedding2 = vector_embedding(ALL_MINILM_L6_V2 using mi.item_description as data)
        , mv.embedding2_model = l_model
    using menu_items mi
    where mv.item_id = mi.item_id;
    dbms_output.put_line('Updated ' || sql%rowcount || ' embeddings using ' || l_model);
    dbms_output.put_line('Total duration: ' || to_char(localtimestamp - l_start));
    
    dbms_output.put_line(c_divider_line);
    l_start := localtimestamp;
    l_model := 'ALL_MINILM_L12_V2';
    
    update menu_vectors mv
    set 
        mv.embedding3 = vector_embedding(ALL_MINILM_L12_V2 using mi.item_description as data)
        , mv.embedding3_model = l_model
    using menu_items mi
    where mv.item_id = mi.item_id;
    dbms_output.put_line('Updated ' || sql%rowcount || ' embeddings using ' || l_model);
    dbms_output.put_line('Total duration: ' || to_char(localtimestamp - l_start));    
    
    commit;

end;
/

/* SCRIPT OUTPUT

create embeddings using ALL_MINILM_L12_V2, ALL_MINILM_L6_V2, MXBAI_EMBED_XSMALL_V1 and MXBAI_EMBED_LARGE_V1
--------------------------------------------------------------------------------
Updated 352 embeddings using MXBAI_EMBED_XSMALL_V1
Total duration: +000000000 00:00:04.627354000
--------------------------------------------------------------------------------
Updated 352 embeddings using MXBAI_EMBED_LARGE_V1
Total duration: +000000000 00:01:56.648343000
--------------------------------------------------------------------------------
Updated 352 embeddings using ALL_MINILM_L6_V2
Total duration: +000000000 00:00:07.567380000
--------------------------------------------------------------------------------
Updated 352 embeddings using ALL_MINILM_L12_V2
Total duration: +000000000 00:00:14.729686000


PL/SQL procedure successfully completed.



*/