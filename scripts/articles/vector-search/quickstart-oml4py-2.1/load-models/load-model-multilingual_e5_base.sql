
--load-model-multilingual_e5_base.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'multilingual-e5-base.onnx',
        'multilingual_e5_base');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'MULTILINGUAL_E5_BASE'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'MULTILINGUAL_E5_BASE'
order by attribute_name
/

    
