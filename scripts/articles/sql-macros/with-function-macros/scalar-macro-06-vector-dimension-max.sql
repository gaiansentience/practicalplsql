--scalar-macro-06-vector-dimension-max.sql
--Note: vectors are only supported in Oracle 23ai and higher
column vec format a60
column vec_dim_range format a30

with 
    function vector_dimension_range(
        p_vector in vector
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'~
            select min(j.dim) || ' to ' || max(j.dim) 
            from json_table(
                from_vector(p_vector), '$[*]' 
                columns (dim number path '$')
                ) j
            ~';
    end vector_dimension_range;

base(vec) as (
    select to_vector('[-3,4,-5,6]',*,int8) union all
    select to_vector('[0.345, 0.112, -2.17]', *, float32)
)
select 
    b.vec
    , vector_dimension_range(b.vec) as vec_dim_range
from base b
/

/*
VEC                                                          VEC_DIM_RANGE                 
------------------------------------------------------------ ------------------------------
[-3,4,-5,6]                                                  -5 to 6                       
[3.44999999E-001,1.12000003E-001,-2.17000008E+000]           -2.17000008 to .344999999     
*/