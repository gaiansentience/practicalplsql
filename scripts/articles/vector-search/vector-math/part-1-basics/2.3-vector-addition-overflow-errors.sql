--2.3-vector-addition-overflow-errors.sql

set serveroutput on;

prompt overflow results in null
declare 
    v1 vector := vector('[127,-128]', *, int8);
    v2 vector := vector('[0, 0]', *, int8);
begin
    show_vector_math('+', v1, v2, v1 + v2);
    
    v2 := vector('[1,0]', *, int8);
    show_vector_math('+', v1, v2, v1 + v2);
    
    v2 := vector('[0,-1]', *, int8);
    show_vector_math('+', v1, v2, v1 + v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
/*
[127,-128] INT8 + [0,0] INT8 = [127,-128] INT8
[127,-128] INT8 + [1,0] INT8 = NULL
[127,-128] INT8 + [0,-1] INT8 = NULL
*/

prompt creating the overflow in SQL shows the error
declare 
    v1 vector := vector('[41,127]', *, int8);
    v2 vector := vector('[1, 1]', *, int8);
    v3 vector;
begin
    select v1 + v2 into v3;
    show_vector_math('+', v1, v2, v3);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51806: Vector column is not properly formatted (dimension value 0 is outside the allowed precision range).
--error message is not reporting the dimension correctly here

prompt changing one of the operands to a different format fixes the overflow error
declare 
    v1 vector := vector('[41,127]', *, int8);
    v2 vector := vector('[1, 1]', *, float32);
begin
    show_vector_math('+', v1, v2, v1 + v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[41,127] INT8 + [1.0E+000,1.0E+000] FLOAT32 = [4.2E+001,1.28E+002] FLOAT32