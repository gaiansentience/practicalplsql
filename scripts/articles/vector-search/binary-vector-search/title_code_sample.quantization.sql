set serveroutput on;

declare
    v_float64 vector(*, float64);
    v_float32 vector(*, float32);
    v_int8    vector(*, int8);
    v_binary  vector(*, binary);    
begin
    v_float64 := to_vector(
        '[
           -6.28318530717958647692,
           -1.41421356237309504880,
            3.14159265358979323846,
           -1.61803398874989484820,
            2.71828182845904523536,
           -0.56714329040978387299,
            2.39996322972865332223,
           -0.83462684167407318628
        ]'
        , *, float64);   
    dbms_output.put_line(vector_serialize(v_float64));
    
    select vector(v_float64, 8, float32) into v_float32;
    dbms_output.put_line(vector_serialize(v_float32));
    
    select vector(v_float32, 8, int8) into v_int8;
    dbms_output.put_line(vector_serialize(v_int8));
    
    --select to_vector(v_int8, 8, binary) into v_binary;
    select to_binary_vector(v_int8) into v_binary;
    dbms_output.put_line(vector_serialize(v_binary));
    
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/