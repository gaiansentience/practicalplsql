   
--load-model-stsb_xlm_r_multilingual.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'stsb-xlm-r-multilingual.onnx',
        'stsb_xlm_r_multilingual');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'STSB_XLM_R_MULTILINGUAL'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'STSB_XLM_R_MULTILINGUAL'
order by attribute_name
/

    
