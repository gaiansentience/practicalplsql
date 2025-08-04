--test.function.to_binary_vector.menu_vectors.sql

column llm format a22
column source_vector format a24
column converted_vector format a24

prompt test the scalar macro with the menu_vectors table

prompt convert the embeddings created with MXBAI_EMBED_XSMALL_V1 in menu_vectors (show timing)
set timing on;

select 
    count(*) items
    , any_value(llm) as llm
    , any_value(v_dim_cnt) || ' '
        || any_value(v_dim_fmt) 
        || ' dimensions' as source_vector
    , any_value(v_binary_dim_cnt) || ' '
        || any_value(v_binary_dim_fmt) 
        || ' dimensions' as converted_vector    
from 
    (
    select
        item_id, llm, v_dim_cnt, v_dim_fmt
        , vector_dimension_count(v_binary) as v_binary_dim_cnt
        , vector_dimension_format(v_binary) as v_binary_dim_fmt
    from
        (
        select 
            item_id, embedding_model as llm
            , vector_dimension_count(embedding) as v_dim_cnt
            , vector_dimension_format(embedding) as v_dim_fmt
            , to_binary_vector(embedding) as v_binary
        from menu_vectors
        )
    )
/

prompt convert the embeddings created with MXBAI_EMBED_LARGE_V1 in menu_vectors (show timing)

select 
    count(*) items
    , any_value(llm) as llm
    , any_value(v_dim_cnt) || ' '
        || any_value(v_dim_fmt) 
        || ' dimensions' as source_vector
    , any_value(v_binary_dim_cnt) || ' '
        || any_value(v_binary_dim_fmt) 
        || ' dimensions' as converted_vector   
from 
    (
    select
        item_id, llm, v_dim_cnt, v_dim_fmt
        , vector_dimension_count(v_binary) as v_binary_dim_cnt
        , vector_dimension_format(v_binary) as v_binary_dim_fmt
    from
        (
        select 
            item_id, embedding1_model as llm
            , vector_dimension_count(embedding1) as v_dim_cnt
            , vector_dimension_format(embedding1) as v_dim_fmt
            , to_binary_vector(embedding1) as v_binary
        from menu_vectors
        )
    )
/


set timing off

/*
test the scalar macro with the menu_vectors table
convert the embeddings created with MXBAI_EMBED_XSMALL_V1 in menu_vectors (show timing)

     ITEMS LLM                    SOURCE_VECTOR            CONVERTED_VECTOR        
---------- ---------------------- ------------------------ ------------------------
       352 MXBAI_EMBED_XSMALL_V1  384 FLOAT32 dimensions   384 BINARY dimensions   

Elapsed: 00:00:00.136
convert the embeddings created with MXBAI_EMBED_LARGE_V1 in menu_vectors (show timing)

     ITEMS LLM                    SOURCE_VECTOR            CONVERTED_VECTOR        
---------- ---------------------- ------------------------ ------------------------
       352 MXBAI_EMBED_LARGE_V1   1024 FLOAT32 dimensions  1024 BINARY dimensions  

Elapsed: 00:00:00.350


*/