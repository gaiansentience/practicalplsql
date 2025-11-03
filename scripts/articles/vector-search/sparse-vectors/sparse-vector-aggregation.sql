--sparse-vector-aggregation.sql

with base(v_text) as (
    values        
        ('[[0,3,5],[11,33,77]]')
        , ('[[3,4,6],[22,15,42]]')
        , ('[[2,7],[14,85]]')
), base_vectors as (
    select to_vector(v_text, 8, int8, sparse) as v
    from base
)
select avg(v) as v_avg
from base_vectors
/
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Arithmetic operations between sparse and dense vectors"

with base(v_text) as (
    values        
        ('[[0,3,5],[11,33,77]]')
        , ('[[3,4,6],[22,15,42]]')
        , ('[[2,7],[14,85]]')
), base_vectors as (
    select to_vector(v_text, 8, int8, sparse) as v
    from base
)
select sum(v) as v_sum
from base_vectors
/
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Arithmetic operations between sparse and dense vectors"
