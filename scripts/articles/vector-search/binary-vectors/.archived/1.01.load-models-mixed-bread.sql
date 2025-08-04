--1.01.load-models-mixed-bread.sql

set serveroutput on;
declare
    procedure load_model(f in varchar2, m in varchar2)
    is
        l_info varchar2(100);
    begin
        dbms_vector.load_onnx_model('ML_MODELS_DIR', f, m);
        
        dbms_output.put_line('Loaded ONNX Model ' || l_model);
        
        select a.vector_info into l_info
        from user_mining_model_attributes a
        where
            a.model_name = upper(m)
            and a.attribute_type = 'VECTOR';     
            
        dbms_output.put_line('Model generates ' || l_info);   
    end load_model;        
begin
    load_model('mxbai-embed-large-v1.onnx', 'mxbai_embed_large_v1');    
    load_model('mxbai-embed-xsmall-v1.onnx', 'mxbai_embed_xsmall_v1');

end;
/

/* SCRIPT OUTPUT
Loaded ONNX Model mxbai_embed_large_v1
Model generates VECTOR(1024,FLOAT32)
*/