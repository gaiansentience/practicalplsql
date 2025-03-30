--aggregating vectors

--sum(vec)  avg(vec)

set serveroutput on;
declare 
    v1 vector;
    v2 vector;
    v3 vector(*, *);
    function vector_and_fmt(v in vector) return varchar2
    is
    begin
        return vector_dimension_format(v) || ' ' || from_vector(v);
    end vector_and_fmt;    
    procedure p(operation in varchar2, v1 in vector, v2 in vector, v3 in vector)
    is
    begin
        dbms_output.put_line(vector_and_fmt(v1) || operation || vector_and_fmt(v2) || ' = ' || vector_and_fmt(v3));
    end p;
begin
    v1 := vector('[1,2,3,4]', 4, int8);
    v2 := vector('[4,3,2,1]', 4, int8);

    /*
    begin
        v3 := v1 / v2;
        p(' / ', v1, v2, v3);
        --PLS-00999: implementation restriction (may be temporary) Dimension-wise vector divide
    exception
        when others then
            dbms_output.put_line(sqlerrm);
    end;
    */
    
    v3 := v1 - v2;
    p(' - ', v1, v2, v3);
    
    v3 := v1 + v2;
    p(' + ', v1, v2, v3);

    select sum(v1) into v3
    connect by level <= 3;
--    v3 := v1 * 3;
--    PLS-00306: wrong number or types of arguments in call to '*'
    v2 := null;
    p(' * 3' , v1, v2, v3);
    
    v3 := v1 + null;
    p(' + null ' , v1, v2, v3);

    v1 := vector('[1,2,3]', 3, int8);
    v2 := vector('[3,2,1]', 3, int8);
    v3 := v1 + v2;
    p(' + ', v1, v2, v3);

    v1 := vector('[1,2,3,4]', 4, float32);
    v2 := vector('[127,126,125,124]', 4, int8);
    v3 := v1 + v2;
    p(' + ', v1, v2, v3);

    v1 := vector('[1,2,3,4]', 4, int8);
    v2 := vector('[4,3,2,1]', 4, int8);    
    v3 := v1 * v2;
    p(' * ', v1, v2, v3);

    v1 := vector('[1,2,3,4]', 4, int8);
    v2 := vector('[11,22,33,44]', 4, int8);
    v3 := v1 * v2;
    p(' * ', v1, v2, v3);

    v1 := vector('[1,2,3,4]', 4, int8);
    v2 := vector('[11,22,33,44]', 4, float32);
    v3 := v1 * v2;
    p(' * ', v1, v2, v3);

    v1 := vector('[1,2,3,4]', 4, int8);
    v2 := vector('[11,22,33,44]', 4, float64);
    v3 := v1 * v2;
    p(' * ', v1, v2, v3);

    
--    dbms_output.put_line(vector_dimension_format(v3));
end;
/

---int8 +-* float32 => float32
---float64 +-* float64 => float64
--int8 +-* int8 overflow => null
--vector division not allowed --PLS-00999: implementation restriction (may be temporary) Dimension-wise vector divide

--in sql can calculate SUM or AVG of vector
with base(vec) as (
values (vector('[1,2,3,4]')),(vector('[2,3,4,5]'))
)
select avg(vec), sum(vec/vec) -- , sum(vec) over () as sumvec
from base
/
--sum vec/vec
--ORA-03001: unimplemented feature
--ORA-00722: Feature "Dimension-wise vector division"