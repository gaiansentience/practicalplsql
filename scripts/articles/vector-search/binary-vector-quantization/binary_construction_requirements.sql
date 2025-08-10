--binary_construction_requirements.sql
set feedback off;

set serveroutput on;

declare
    v_textual_input varchar2(100) := '[-6,-1,3,-2,3,-1,2,-1]';
    v_int8    vector(*, int8);
    v_binary  vector(*, binary);    
begin
    v_int8 := to_vector(v_textual_input, 8, int8);
    select to_vector(v_int8, 8, binary) into v_binary;
exception 
    when others then 
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51814: Vector of BINARY format cannot have any operation performed with vector of any other type.


declare
    v_textual_input varchar2(100) := '[-6,-1,3,-2,3,-1,2,-1]';
    v_binary  vector(*, binary);    
begin
    v_binary :=  to_vector(v_textual_input, 8, binary);    
exception 
    when others then 
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51806: Vector column is not properly formatted (dimension value 0 is outside the allowed precision range).


declare
    v_textual_input varchar2(100) := '[0,0,1,0,1,0,1,0]';
    v_binary  vector(*, binary);    
begin
    v_binary := to_vector(v_textual_input, 8, binary);    
exception 
    when others then 
        dbms_output.put_line(sqlerrm);
end;
/
--ORA-51867: Dimension count of the constructed vector(64) does not match the dimension count argument (8) of the constructor.


declare
    v_textual_input varchar2(100) := '[42]';
    v_binary  vector(*, binary);    
begin        
    v_binary := to_vector(v_textual_input, 8, binary);    
    dbms_output.put_line(vector_serialize(v_binary));
end;
/
--[42]