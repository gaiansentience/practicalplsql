--quantize_vectors.recipe_vectors.sql
set serveroutput on;
prompt use the macro to quantize the vectors in the recipe vectors table


set timing on;
begin

    update recipe_vectors r
    set r.embedding_binary = to_binary_vector(r.embedding);

    dbms_output.put_line('Converted ' || sql%rowcount || ' vectors to binary format');
    
    commit;
    
end;
/
set timing off;


/*
use the macro to quantize the vectors in the recipe vectors table
Converted 15 vectors to binary format


PL/SQL procedure successfully completed.

Elapsed: 00:00:00.026
*/