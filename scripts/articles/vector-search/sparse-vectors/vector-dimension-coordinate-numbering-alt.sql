


with base(v_text) as (
values 
    ('[1,0,0,0]')
    , ('[0,2,0,0]')
    , ('[0,0,3,0]')
    , ('[0,0,0,4]')
), vbase as (
select
    v_text
    , to_vector(v_text, 4, int8, dense) as v_dense 
from base
)
select
    v_text, v_dense
    , from_vector(v_dense returning varchar2(1000) format sparse) as v_sparse_text
from vbase
/