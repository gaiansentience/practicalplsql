--drop.models.all_miniLM.sql

set serveroutput on;
begin
    dbms_vector.drop_onnx_model('all_MiniLM_L6_v2', true);    
    dbms_vector.drop_onnx_model('all_MiniLM_L12_v2', true);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
