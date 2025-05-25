
--load-model-snowflake_arctic_embed_m.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'snowflake-arctic-embed-m.onnx',
        'snowflake_arctic_embed_m');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'SNOWFLAKE_ARCTIC_EMBED_M'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'SNOWFLAKE_ARCTIC_EMBED_M'
order by attribute_name
/

