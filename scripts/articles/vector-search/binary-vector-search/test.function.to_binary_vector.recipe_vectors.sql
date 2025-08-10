--test.function.to_binary_vector.recipe_vectors.sql


column v_model format a22
column v_fmt format a9
column v_bin_fmt format a9


prompt test the scalar macro


prompt test the macro with the recipe_vectors table
select
    v_model
    , v_fmt, v_dims
    , vector_dimension_format(v_binary) as v_bin_fmt
    , vector_dimension_count(v_binary) as v_bin_dims
from
    (
    select 
        r.embedding_model as v_model
        , vector_dimension_format(r.embedding) as v_fmt
        , vector_dimension_count(r.embedding) as v_dims
        , to_binary_vector(r.embedding) as v_binary
    from recipe_vectors r
    )
fetch first row only
/

/*
test the scalar macro
test the macro with the recipe_vectors table

V_MODEL                V_FMT         V_DIMS V_BIN_FMT V_BIN_DIMS
---------------------- --------- ---------- --------- ----------
MXBAI_EMBED_XSMALL_V1  FLOAT32          384 BINARY           384

*/