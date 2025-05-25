set serveroutput on;

declare
    l_models_dir varchar2(50) := 'ML_MODELS_DIR';
    type t_model is record(onnx_filename varchar2(100), model_name varchar2(100));
    type t_models is table of t_model;
    l_models t_models := t_models();

begin

l_models := t_models(
    t_model('clip-vit-large-patch14_img.onnx', 'clip_vit_large_patch14_img'),
    t_model('clip-vit-large-patch14_txt.onnx', 'clip_vit_large_patch14_txt'),
    t_model('gender-classification.onnx', 'gender_classification'),
    t_model('nsfw_image_detection.onnx', 'nsfw_image_detection'),
    t_model('resnet-18.onnx', 'resnet_18'),
    t_model('resnet-50.onnx', 'resnet_50'),
    t_model('vit-age-classifier.onnx', 'vit_age_classifier'),
    t_model('vit-base-nsfw-detector.onnx', 'vit_base_nsfw_detector'),
    t_model('vit-base-patch16-224.onnx', 'vit_base_patch16_224'),
    t_model('vit-face-expression.onnx', 'vit_face_expression'),
    t_model('vit-small-patch16-224.onnx', 'vit_small_patch16_224'),
    t_model('vit-tiny-patch16-224.onnx', 'vit_tiny_patch16_224')
    );

dbms_output.put_line('Loading ' || l_models.count || ' onnx models');

for v in values of l_models loop

    dbms_vector.load_onnx_model(l_models_dir, v.onnx_filename, v.model_name);
    
    dbms_output.put_line(v.onnx_filename || ' loaded successfully as ' || v.model_name);
    
end loop;

end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
order by model_name
/

select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name in (
    select model_name
    from user_mining_models
    where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
    )
order by model_name, attribute_name
/