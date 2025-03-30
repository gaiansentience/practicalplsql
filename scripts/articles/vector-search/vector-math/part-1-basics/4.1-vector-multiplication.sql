--4.1-vector-multiplication.sql

set serveroutput on;

prompt Vector multiplication multiplies each dimension separately
declare 
    v1 vector;
    v2 vector;
begin
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, int8);    
    show_vector_math('*', v1, v2, v1 * v2);
    
    v1 := vector('[15,23.5]', *, float32);
    v2 := vector('[275,365]', *, float32);    
    show_vector_math('*', v1, v2, v1 * v2);
end;
/
/*
[1,2] INT8 * [3,4] INT8 = [3,8] INT8
[1.5E+001,2.35E+001] FLOAT32 * [2.75E+002,3.65E+002] FLOAT32 = [4.125E+003,8.5775E+003] FLOAT32
*/

prompt multiplying by null returns null
declare 
    v1 vector := vector('[4,2]', *, int8);
begin
    show_vector_math('*', v1, null, v1 * null);
end;
/
--[4,2] INT8 * NULL = NULL


prompt the result dimension format is always the larger format when different
declare 
    v1 vector;
    v2 vector;
begin
    dbms_output.put_line('int8 * float32 = float32');
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, float32);
    show_vector_math('*', v1, v2, v1 * v2);
    
    dbms_output.put_line('int8 * float64 = float64');
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, float64);
    show_vector_math('*', v1, v2, v1 * v2);
    
    dbms_output.put_line('float32 * float64 = float64');
    v1 := vector('[1,2]', *, float32);
    v2 := vector('[3,4]', *, float64);
    show_vector_math('*', v1, v2, v1 * v2);
end;
/
/*
int8 * float32 = float32
[1,2] INT8 * [3.0E+000,4.0E+000] FLOAT32 = [3.0E+000,8.0E+000] FLOAT32
int8 * float64 = float64
[1,2] INT8 * [3.0E+000,4.0E+000] FLOAT64 = [3.0E+000,8.0E+000] FLOAT64
float32 * float64 = float64
[1.0E+000,2.0E+000] FLOAT32 * [3.0E+000,4.0E+000] FLOAT64 = [3.0E+000,8.0E+000] FLOAT64
*/

prompt overflow results in null
declare 
    v1 vector := vector('[42,11]', *, int8);
    v2 vector := vector('[8, 22]', *, int8);
begin
    show_vector_math('*', v1, v2, v1 * v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[42,11] INT8 * [8,22] INT8 = NULL


prompt changing one of the operands to a different format fixes the overflow error
declare 
    v1 vector := vector('[42,11]', *, int8);
    v2 vector := vector('[8, 22]', *, float32);
begin
    show_vector_math('*', v1, v2, v1 * v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[42,11] INT8 * [8.0E+000,2.2E+001] FLOAT32 = [3.36E+002,2.42E+002] FLOAT32