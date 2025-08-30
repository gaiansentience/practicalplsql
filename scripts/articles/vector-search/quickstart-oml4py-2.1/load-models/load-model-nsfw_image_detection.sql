
--load-model-nsfw_image_detection.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'nsfw_image_detection.onnx',
        'nsfw_image_detection');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'NSFW_IMAGE_DETECTION'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'NSFW_IMAGE_DETECTION'
order by attribute_name
/

    
