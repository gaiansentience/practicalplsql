
--load-model-clip_vit_large_patch14_img.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'clip-vit-large-patch14_img.onnx',
        'clip_vit_large_patch14_img');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'CLIP_VIT_LARGE_PATCH14_IMG'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'CLIP_VIT_LARGE_PATCH14_IMG'
order by attribute_name
/

