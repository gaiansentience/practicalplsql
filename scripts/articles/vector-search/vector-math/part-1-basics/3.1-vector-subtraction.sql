--3.1-vector-subtraction.sql

set serveroutput on;

prompt Vector subtraction adds each dimension separately
declare 
    v1 vector;
    v2 vector;
begin
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, int8);    
    show_vector_math('-', v1, v2, v1 - v2);
    
    v1 := vector('[15,23.5]', *, float32);
    v2 := vector('[275,365]', *, float32);    
    show_vector_math('-', v1, v2, v1 - v2);
end;
/
/*
[1,2] INT8 - [3,4] INT8 = [-2,-2] INT8
[1.5E+001,2.35E+001] FLOAT32 - [2.75E+002,3.65E+002] FLOAT32 = [-2.6E+002,-3.415E+002] FLOAT32
*/

prompt subtracting null returns null
declare 
    v1 vector := vector('[4,2]', *, int8);
begin
    show_vector_math('-', v1, null, v1 - null);
end;
/
--[4,2] INT8 - NULL = NULL


prompt overflow results in null
declare 
    v1 vector := vector('[-128,42]', *, int8);
    v2 vector := vector('[1, 0]', *, int8);
begin
    show_vector_math('-', v1, v2, v1 - v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[-128,42] INT8 - [1,0] INT8 = NULL


prompt changing one of the operands to a different format fixes the overflow error
declare 
    v1 vector := vector('[-128,42]', *, int8);
    v2 vector := vector('[1, 0]', *, float32);
begin
    show_vector_math('-', v1, v2, v1 - v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[-128,42] INT8 - [1.0E+000,0] FLOAT32 = [-1.29E+002,4.2E+001] FLOAT32