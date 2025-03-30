--2.1-vector-addition.sql

set serveroutput on;

prompt Vector addition adds each dimension separately
declare 
    v1 vector;
    v2 vector;
begin
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, int8);    
    show_vector_math('+', v1, v2, v1 + v2);
    
    v1 := vector('[15,23.5]', *, float32);
    v2 := vector('[275,365]', *, float32);    
    show_vector_math('+', v1, v2, v1 + v2);
end;
/
/*
[1,2] INT8 + [3,4] INT8 = [4,6] INT8
[1.5E+001,2.35E+001] FLOAT32 + [2.75E+002,3.65E+002] FLOAT32 = [2.9E+002,3.885E+002] FLOAT32
*/

prompt adding null returns null
declare 
    v1 vector := vector('[4,2]', *, int8);
begin
    show_vector_math('+', v1, null, v1 + null);
end;
/
--[4,2] INT8 + NULL = NULL


