--construct-sparse-vector-from-vectors.sql
column v_serialized format a50

--construct a sparse vector from a dense vector
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            to_vector(
                '[0,0,3,0,7,0,0,0]'
                , 8
                , int8
                , dense
                )
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

--construct a dense vector from a sparse vector
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            to_vector(
                '[8,[0,3,5],[11,33,77]]'
                , 8
                , int8
                , sparse
                )
            , 8
            , int8
            , dense
            ) as v
    )
/

/*
V_SERIALIZED                                      
--------------------------------------------------
[11,0,0,33,0,77,0,0]
*/