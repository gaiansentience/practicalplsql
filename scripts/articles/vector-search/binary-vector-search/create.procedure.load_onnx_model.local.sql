--create.procedure.load_onnx_model.local.sql


create or replace procedure load_onnx_model(f in varchar2, m in varchar2)
is
    l_info varchar2(100);
begin
    dbms_vector.load_onnx_model('ML_MODELS_DIR', f, m);
    
    dbms_output.put_line('Loaded ONNX Model ' || m);
    
    select a.vector_info into l_info
    from user_mining_model_attributes a
    where
        a.model_name = upper(m)
        and a.attribute_type = 'VECTOR';     
        
    dbms_output.put_line('Model generates ' || l_info);  
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end load_onnx_model;
/
