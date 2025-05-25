
--load-model-bge_base_en_v1.5_noquantize.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'bge-base-en-v1.5-noquantize.onnx',
        'bge_base_en_v1_5_noquantize');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'BGE_BASE_EN_V1_5_NOQUANTIZE'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'BGE_BASE_EN_V1_5_NOQUANTIZE'
order by attribute_name
/

    
