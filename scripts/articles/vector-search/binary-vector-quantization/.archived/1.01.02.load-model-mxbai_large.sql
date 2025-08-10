   
--1.1.2.load-model-mxbai_large.sql 
set serveroutput on;
declare
    l_file varchar2(100);
    l_model varchar2(100);
    l_info varchar2(100);
begin
    l_file := 'mxbai-embed-large-v1.onnx';
    l_model := 'mxbai_embed_large_v1';
    dbms_vector.load_onnx_model('ML_MODELS_DIR', l_file, l_model);
    
    select a.vector_info into l_info
    from user_mining_model_attributes a
    where
        a.model_name = upper(l_model)
        and a.attribute_type = 'VECTOR';
        
    dbms_output.put_line('Loaded ONNX Model ' || l_model);
    dbms_output.put_line('Model generates ' || l_info);

end;
/

/* SCRIPT OUTPUT
Loaded ONNX Model mxbai_embed_large_v1
Model generates VECTOR(1024,FLOAT32)
*/