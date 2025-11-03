--construct-sparse-vector-from-text.sql
column v_serialized format a50

--must specify sparse when text format is sparse
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[8,[3, 5],[3.42, 5.555]]'
            ) as v
    )
/
--ORA-51833: Textual input conversion between sparse and dense vector is not supported.

--cannot use dense textual input with sparse keyword
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[0,0,0,3.42000008E+000,0,5.55499983E+000,0,0]'
            , 8
            , float32
            , sparse
            ) as v
    )
/
--ORA-51833: Textual input conversion between sparse and dense vector is not supported.

--optionally specify dimension count in textual input
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[8,[3, 5],[3.42, 5.555]]'
            , *
            , float32
            , sparse) as v
    )
/
/*
V_SERIALIZED                                      
--------------------------------------------------
[8,[3,5],[3.42000008E+000,5.55499983E+000]]
*/

--specify dimension count with constructor argument
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[[2, 4],[2.42, 4.42]]'
            , 8
            , float32
            , sparse) as v
    )
/

/*
V_SERIALIZED                                      
--------------------------------------------------
[8,[2,4],[2.42000008E+000,4.42000008E+000]]
*/


--dimension count is required in text or as argument
select from_vector(v) as v_serialized
from
    (
    select 
        to_vector(
            '[[2, 4],[2.42, 4.42]]'
            , *
            , float32
            , sparse) as v
    )
/

--ORA-51819: Sparse vector input is missing dimension count.
