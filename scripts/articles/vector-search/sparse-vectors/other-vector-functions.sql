--other-vector-functions.sql
column dim_fmt format a10
set serveroutput on;

select
    vector_dimension_count(v) as dim_count
    , vector_dimension_format(v) as dim_fmt
    , vector_norm(v) as norm
from
    (
    select 
        vector('[8,[0,3,5],[11,33,77]]',*,int8,sparse) as v
    )
/
/*
 DIM_COUNT DIM_FMT          NORM
---------- ---------- ----------
         8 INT8       8.449E+001
*/


declare
    v vector;
begin
    v := vector('[8,[0,3,5],[11,33,77]]',*,int8,sparse);
    dbms_output.put_line('Dimension Count: ' || vector_dimension_count(v));
    dbms_output.put_line('Dimension Format: ' || vector_dimension_format(v));
    dbms_output.put_line('Vector Norm: ' || vector_norm(v));
end;
/
/*
Dimension Count: 8
Dimension Format: INT8
Vector Norm: 8.4492603226554692E+001
*/

select
    vector_distance(
        vector('[[0,3,5],[11,33,77]]', 8, int8, sparse)
        , vector('[[3,4,6],[22,15,42]]', 8, int8, sparse)
        , cosine
        ) as similarity
/

/*
SIMILARITY
----------
8.272E-001
*/

declare
    v1 vector;
    v2 vector;
    d binary_double;
begin
    v1 := to_vector('[8,[0,3,5],[11,33,77]]', 8, int8, sparse);
    v2 := to_vector('[8,[3,4,6],[22,15,42]]', 8, int8, sparse);

    d := vector_distance(v1, v2, cosine);
    dbms_output.put_line(d);
end;
/

--8.2721506596093497E-001

--vector distance calculation is not supported between sparse and dense vectors
select
    vector_distance(
        vector('[[0,3,5],[11,33,77]]', 8, int8, sparse)
        , vector('[0,0,0,22,15,0,42,0]', 8, int8, dense)
        , cosine
        ) as similarity
/
--ORA-51834: Distance computation between sparse and dense vector is not supported.
