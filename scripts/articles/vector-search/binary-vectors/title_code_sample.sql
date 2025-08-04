--title_code_sample.sql
--requires create.procedure.print_vector_details.sql
prompt create a procedure to show vector information
@create.procedure.print_vector_details.sql

set serveroutput on;
declare
    v_float32 vector(*, float32);
    v_int8    vector(*, int8);
    v_binary  vector(*, binary);    
begin
    v_float32 := to_vector('[-1.234,-2.567,3.432,-4.50543,5.0032,-6.2311,7.777,-8.030204]', *, float32);    
    v_int8    := to_vector('[-1,-2,3,-4,5,-6,7,-8]', 8, int8);
    v_binary  := to_vector('[42]', *, binary);
    
    print_vector_details(v_float32);
    print_vector_details(v_int8);
    print_vector_details(v_binary);
end;
/

/* SCRIPT OUTPUT:

create a procedure to show vector information

Procedure PRINT_VECTOR_DETAILS compiled

Dimension Count = 8
Dimension Format = FLOAT32
Serialized Vector = [-1.23399997E+000,-2.56699991E+000,3.43199992E+000,-4.50543022E+000,5.00320005E+000,-6.23110008E+000,7.77699995E+000,-8.03020382E+000]
Dimension Count = 8
Dimension Format = INT8
Serialized Vector = [-1,-2,3,-4,5,-6,7,-8]
Dimension Count = 8
Dimension Format = BINARY
Serialized Vector = [42]


PL/SQL procedure successfully completed.


*/