--sparse-vector-arithmetic.sql

with base(v1, v2) as (
    select        
        vector('[[0,3,5],[11,33,77]]', 8, int8, sparse)
        , vector('[[3,4,6],[22,15,42]]', 8, int8, sparse)
)
select v1 + v2 as v_add
from base
/
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Arithmetic operations between sparse and dense vectors"

with base(v1, v2) as (
    select        
        vector('[[0,3,5],[11,33,77]]', 8, int8, sparse)
        , vector('[[3,4,6],[22,15,42]]', 8, int8, sparse)
)
select v1 - v2 as v_subtract
from base
/
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Arithmetic operations between sparse and dense vectors"

with base(v1, v2) as (
    select        
        vector('[[0,3,5],[11,33,77]]', 8, int8, sparse)
        , vector('[[3,4,6],[22,15,42]]', 8, int8, sparse)
)
select v1 * v2 as v_multiply
from base
/
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Arithmetic operations between sparse and dense vectors"

