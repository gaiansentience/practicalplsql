set serveroutput on;
declare
    v_sparse vector(*, int8, sparse);
    v_dense_text varchar2(100);
begin
    --construct a sparse vector from textual input
    v_sparse := to_vector('[16,[4,6],[7,9]]', *, int8, sparse);
    
    select vector_serialize(v_sparse returning clob format dense)
    into v_dense_text;
    dbms_output.put_line('Serialized to dense vector: ' || v_dense_text);
    
end;
/

--Serialized to dense vector: [0,0,0,0,7,0,9,0,0,0,0,0,0,0,0,0]

