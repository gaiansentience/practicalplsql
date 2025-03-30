--2.2-vector-addition-dimension-formats.sql

set serveroutput on;

prompt the result dimension format is always the larger format when different
declare 
    v1 vector;
    v2 vector;
begin
    dbms_output.put_line('int8 + float32 = float32');
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, float32);
    show_vector_math('+', v1, v2, v1 + v2);
    
    dbms_output.put_line('int8 + float64 = float64');
    v1 := vector('[1,2]', *, int8);
    v2 := vector('[3,4]', *, float64);
    show_vector_math('+', v1, v2, v1 + v2);
    
    dbms_output.put_line('float32 + float64 = float64');
    v1 := vector('[1,2]', *, float32);
    v2 := vector('[3,4]', *, float64);
    show_vector_math('+', v1, v2, v1 + v2);
end;
/
/*
int8 + float32 = float32
[1,2] INT8 + [3.0E+000,4.0E+000] FLOAT32 = [4.0E+000,6.0E+000] FLOAT32
int8 + float64 = float64
[1,2] INT8 + [3.0E+000,4.0E+000] FLOAT64 = [4.0E+000,6.0E+000] FLOAT64
float32 + float64 = float64
[1.0E+000,2.0E+000] FLOAT32 + [3.0E+000,4.0E+000] FLOAT64 = [4.0E+000,6.0E+000] FLOAT64
*/



prompt No Implicit Format Conversion on Assignment
declare 
    v1 vector := vector('[1,2]', *, int8);
    v2 vector := vector('[3,4]', *, float64);
    v3 vector(*, int8);
begin
    v3 := v1 + v2;
    show_vector_math('+', v1, v2, v3);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51868: Assignment is not supported for vectors with different element formats (FLOAT64, INT8).

prompt explicit conversion of formats works
declare 
    v1 vector := vector('[1,2]', *, int8);
    v2 vector := vector('[3,4]', *, float64);
    v3 vector(*, int8);
begin
    v3 := to_vector(from_vector(v1 + v2), *, int8);
    show_vector_math('+', v1, v2, v3);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[1,2] INT8 + [3.0E+000,4.0E+000] FLOAT64 = [4,6] INT8

prompt Binary vectors are not supported
declare 
    v1 vector := vector('[42]', 8, binary);
    v2 vector := vector('[108]', 8, binary);
begin
    show_vector_math('+', v1, v2, v1 + v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51838: Input vectors with BINARY format are not allowed in vector arithmetic operations.
