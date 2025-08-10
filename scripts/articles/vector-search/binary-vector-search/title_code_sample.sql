--title_code_sample.sql

set serveroutput on;

declare
    v_float64 vector(*, float64);
    v_float32 vector(*, float32);
    v_int8    vector(*, int8);
    v_binary  vector(*, binary);    
begin
    v_float64 := to_vector(
        '[
           -6.28318530717958647692,-1.41421356237309504880,
            3.14159265358979323846,-1.61803398874989484820,
            2.71828182845904523536,-0.56714329040978387299,
            2.39996322972865332223,-0.83462684167407318628
        ]'
        , *, float64);   
    dbms_output.put_line(vector_serialize(v_float64));
    
    select vector(v_float64, 8, float32) into v_float32;
    dbms_output.put_line(vector_serialize(v_float32));
    
    select vector(v_float32, 8, int8) into v_int8;
    dbms_output.put_line(vector_serialize(v_int8));
    
    select to_vector(v_int8, 8, binary) into v_binary;
        
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/


/* SCRIPT OUTPUT:

[
-6.2831853071795862E+000,-1.4142135623730951E+000,
3.1415926535897931E+000,-1.6180339887498949E+000,
2.7182818284590451E+000,-5.6714329040978384E-001,
2.3999632297286535E+000,-8.3462684167407319E-001
]

[
-6.28318548E+000,-1.41421354E+000,
3.14159274E+000,-1.61803401E+000,
2.71828175E+000,-5.67143261E-001,
2.39996314E+000,-8.34626853E-001
]

[-6,-1,3,-2,3,-1,2,-1]

ORA-51814: Vector of BINARY format cannot have any operation performed with vector of any other type.

*/

