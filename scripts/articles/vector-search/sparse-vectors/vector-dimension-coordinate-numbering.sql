
---when sparse vectors were introduced in 23.6 dimension coordinates were 1-based
---dimension coordinate numbering is now zero based in 23.9


select banner_full from v$version;


with base (textual_vector) as (
    values
        ('[1,0,0,0,0]'),
        ('[0,1,0,0,0]'),
        ('[0,0,1,0,0]'),
        ('[0,0,0,1,0]'),
        ('[0,0,0,0,1]')
), base_vectors as (
    select
        textual_vector
        , to_vector(textual_vector, 5, int8, dense) as dense_vector
    from base
)
select
    textual_vector
    , dense_vector
    , from_vector(dense_vector returning clob format sparse) as sparse_textual_vector
from base_vectors
/