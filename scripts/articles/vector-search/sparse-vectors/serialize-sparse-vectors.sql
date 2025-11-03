--serialize-sparse-vectors.sql
column v_serialized format a50

--serializing a sparse vector will not change the storage format
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[8,[0,3,5],[11,33,77]]'
            , 8
            , int8
            , sparse
            ) as v
    )
/
/*
V_SERIALIZED                                      
--------------------------------------------------
[8,[2,4],[3,7]]
*/

--sparse vector can be serialized to dense textual format
select from_vector(v format dense) as v_serialized
from
    (
    select 
        to_vector(
            '[8,[0,3,5],[11,33,77]]'
            , 8
            , int8
            , sparse
            ) as v
    )
/
/*
V_SERIALIZED                                      
--------------------------------------------------
[11,0,0,33,0,77,0,0]
*/

--dense vector can be serialized to sparse textual input
select from_vector(v format sparse) as v_serialized
from
    (
    select 
        to_vector(
            '[11,0,0,33,0,77,0,0]'
            , 8
            , int8
            , dense
            ) as v
    )
/

/*
V_SERIALIZED                                      
--------------------------------------------------
[8,[0,3,5],[11,33,77]]
*/