--zero-based-vector-dimension-indices.sql
column serialized_dense format a20
column serialized_sparse format a20

with base (vector_text) as (
    values
        ('[1,0,0,0,0]'),
        ('[0,2,0,0,0]'),
        ('[0,0,3,0,0]'),
        ('[0,0,0,4,0]'),
        ('[0,0,0,0,5]')
), base_vectors as (
    select
        to_vector(vector_text, 5, int8, dense) as v
    from base
)
select
    from_vector(v returning clob format dense) as serialized_dense
    , from_vector(v returning clob format sparse) as serialized_sparse
from base_vectors
/

/*
SERIALIZED_DENSE     SERIALIZED_SPARSE   
-------------------- --------------------
[1,0,0,0,0]          [5,[0],[1]]         
[0,2,0,0,0]          [5,[1],[2]]         
[0,0,3,0,0]          [5,[2],[3]]         
[0,0,0,4,0]          [5,[3],[4]]         
[0,0,0,0,5]          [5,[4],[5]]      
*/