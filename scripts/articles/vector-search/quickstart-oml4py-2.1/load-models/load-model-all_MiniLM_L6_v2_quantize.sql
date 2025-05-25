
--load-model-all_MiniLM_L6_v2_quantize.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'all-MiniLM-L6-v2-quantize.onnx',
        'all_MiniLM_L6_v2_quantize');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'ALL_MINILM_L6_V2_QUANTIZE'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'ALL_MINILM_L6_V2_QUANTIZE'
order by attribute_name
/

    
