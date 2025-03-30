--1.2.procedure.show_vector_math.sql

--Create a test procedure to print a vector equation with its result
create or replace procedure show_vector_math(
    operation in varchar2, 
    v1 in vector, 
    v2 in vector, 
    v3 in vector
)
is
begin
    dbms_output.put_line(
        get_vector_details(v1) 
        || ' ' || operation || ' '
        || get_vector_details(v2) 
        || ' = ' 
        || get_vector_details(v3));
end show_vector_math;
/

--Procedure SHOW_VECTOR_MATH compiled

--Test the procedure with some vectors
set serveroutput on;
declare 
    v1 vector;
    v2 vector;
    v3 vector;
begin
    v1 := to_vector('[1,2]', 2, int8);
    v2 := to_vector('[3,4]', 2, float32);
    v3 := to_vector('[5,6]', 2, float64);
    show_vector_math('JUST TESTING', v1, v2, v3);
end;
/

--[1,2] INT8 JUST TESTING [3.0E+000,4.0E+000] FLOAT32 = [5.0E+000,6.0E+000] FLOAT64