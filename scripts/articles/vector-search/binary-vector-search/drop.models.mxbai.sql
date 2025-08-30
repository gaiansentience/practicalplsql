--drop.models.mxbai.sql

set serveroutput on;
begin
    dbms_vector.drop_onnx_model('mxbai_embed_large_v1', true);    
    dbms_vector.drop_onnx_model('mxbai_embed_xsmall_v1', true);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
