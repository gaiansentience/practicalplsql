--quantize_vectors.menu_vectors.sql
set serveroutput on;

column embedding_model format a24
column embedding1_model format a24
column embedding2_model format a24
column embedding3_model format a24

prompt the menu_vectors table has embeddings generated with all four models:

select distinct 
    embedding_model, embedding1_model
    , embedding2_model, embedding3_model
from menu_vectors
/

prompt use the macro to quantize the all of the vectors in the menu vectors table

set timing on;
begin

    update menu_vectors m
    set 
        --quantize the mixed bread embeddings
        m.embedding_binary = to_binary_vector(m.embedding)
        , m.embedding1_binary = to_binary_vector(m.embedding1)
        --quantize the all_minilm embeddings for comparison
        , m.embedding2_binary = to_binary_vector(m.embedding2)
        , m.embedding3_binary = to_binary_vector(m.embedding3);

    dbms_output.put_line('Converted ' || (sql%rowcount * 4) || ' vectors to binary format');
    
    commit;
    
end;
/
set timing off;


/*
the menu_vectors table has embeddings generated with all four models:

EMBEDDING_MODEL          EMBEDDING1_MODEL         EMBEDDING2_MODEL         EMBEDDING3_MODEL        
------------------------ ------------------------ ------------------------ ------------------------
MXBAI_EMBED_XSMALL_V1    MXBAI_EMBED_LARGE_V1     ALL_MINILM_L6_V2         ALL_MINILM_L12_V2       

use the macro to quantize the all of the vectors in the menu vectors table
Converted 1408 vectors to binary format


PL/SQL procedure successfully completed.

Elapsed: 00:00:00.753
*/

