set heading off;
set pagesize 0;


with base as (
select
'[
{"file_size":133349965, "converted":"May 24 14:15","file_name":"all-MiniLM-L12-v2.onnx"},
{"file_size":33942435, "converted":"May 24 14:17","file_name":"all-MiniLM-L12-v2-quantize.onnx"},
{"file_size":90636502, "converted":"May 24 14:14","file_name":"all-MiniLM-L6-v2.onnx"},
{"file_size":23057150, "converted":"May 24 14:14","file_name":"all-MiniLM-L6-v2-quantize.onnx"},
{"file_size":109759755, "converted":"May 24 14:18","file_name":"all-mpnet-base-v2.onnx"},
{"file_size":436067996, "converted":"May 24 14:21","file_name":"bge-base-en-v1.5-noquantize.onnx"},
{"file_size":109803972, "converted":"May 24 14:20","file_name":"bge-base-en-v1.5.onnx"},
{"file_size":34824663, "converted":"May 24 14:23","file_name":"bge-micro-v2.onnx"},
{"file_size":288905193, "converted":"May 24 15:05","file_name":"bge-reranker-base.onnx"},
{"file_size":133349948, "converted":"May 24 14:19","file_name":"bge-small-en-v1.5.onnx"},
{"file_size":306374798, "converted":"May 24 14:55","file_name":"clip-vit-large-patch14_img.onnx"},
{"file_size":125781199, "converted":"May 24 14:54","file_name":"clip-vit-large-patch14_txt.onnx"},
{"file_size":136470592, "converted":"May 24 14:19","file_name":"distiluse-base-multilingual-cased-v2.onnx"},
{"file_size":109803970, "converted":"May 24 14:29","file_name":"e5-base-v2.onnx"},
{"file_size":133349946, "converted":"May 24 14:28","file_name":"e5-small-v2.onnx"},
{"file_size":345868420, "converted":"May 24 14:44","file_name":"gender-classification.onnx"},
{"file_size":87491318, "converted":"May 24 14:45","file_name":"gender-classification-quantize.onnx"},
{"file_size":218386358, "converted":"May 24 14:26","file_name":"gte-base.onnx"},
{"file_size":67027335, "converted":"May 24 14:27","file_name":"gte-small.onnx"},
{"file_size":45558487, "converted":"May 24 14:24","file_name":"gte-tiny.onnx"},
{"file_size":283205707, "converted":"May 24 15:03","file_name":"multilingual-e5-base.onnx"},
{"file_size":123080154, "converted":"May 24 14:31","file_name":"multilingual-e5-small.onnx"},
{"file_size":90636512, "converted":"May 24 14:18","file_name":"multi-qa-MiniLM-L6-cos-v1.onnx"},
{"file_size":1337125783, "converted":"May 24 14:51","file_name":"mxbai-embed-large-v1-noquantize.onnx"},
{"file_size":335905910, "converted":"May 24 14:48","file_name":"mxbai-embed-large-v1.onnx"},
{"file_size":24462077, "converted":"May 24 14:52","file_name":"mxbai-embed-xsmall-v1.onnx"},
{"file_size":345868413, "converted":"May 24 14:38","file_name":"nsfw_image_detection.onnx"},
{"file_size":87491311, "converted":"May 24 14:39","file_name":"nsfw_image_detection-quantize.onnx"},
{"file_size":283205738, "converted":"May 24 14:59","file_name":"paraphrase-multilingual-mpnet-base-v2.onnx"},
{"file_size":44713103, "converted":"May 24 14:40","file_name":"resnet-18.onnx"},
{"file_size":93980265, "converted":"May 24 14:41","file_name":"resnet-50.onnx"},
{"file_size":109803985, "converted":"May 24 14:33","file_name":"snowflake-arctic-embed-m.onnx"},
{"file_size":133349960, "converted":"May 24 14:32","file_name":"snowflake-arctic-embed-s.onnx"},
{"file_size":90636499, "converted":"May 24 14:32","file_name":"snowflake-arctic-embed-xs.onnx"},
{"file_size":283205722, "converted":"May 24 15:01","file_name":"stsb-xlm-r-multilingual.onnx"},
{"file_size":345868413, "converted":"May 24 14:43","file_name":"vit-age-classifier.onnx"},
{"file_size":347035778, "converted":"May 24 14:39","file_name":"vit-base-nsfw-detector.onnx"},
{"file_size":345868402, "converted":"May 24 14:34","file_name":"vit-base-patch16-224.onnx"},
{"file_size":345868414, "converted":"May 24 14:42","file_name":"vit-face-expression.onnx"},
{"file_size":87565337, "converted":"May 24 14:37","file_name":"vit-small-patch16-224.onnx"},
{"file_size":22557152, "converted":"May 24 14:36","file_name":"vit-tiny-patch16-224.onnx"}
]' as jdoc
), models_base as (
select j.file_name, translate(replace(j.file_name,'.onnx'),'-.','__') as model_name, j.file_size
from base b,
json_table(b.jdoc, '$[*]'
    columns(
        file_size number path '$.file_size.number()',
        file_name varchar2(200) path '$.file_name.string()'
    )
) j
)
select 
    't_model(''' || file_name || ''', ''' || model_name || '''),' as collection_element
from models_base
/


/*
--create the collection for load-all-onnx-models.sql
--reranker and classification models may need special treatment

t_model('all-MiniLM-L12-v2.onnx', 'all_MiniLM_L12_v2'),
t_model('all-MiniLM-L12-v2-quantize.onnx', 'all_MiniLM_L12_v2_quantize'),
t_model('all-MiniLM-L6-v2.onnx', 'all_MiniLM_L6_v2'),
t_model('all-MiniLM-L6-v2-quantize.onnx', 'all_MiniLM_L6_v2_quantize'),
t_model('all-mpnet-base-v2.onnx', 'all_mpnet_base_v2'),
t_model('bge-base-en-v1.5-noquantize.onnx', 'bge_base_en_v1_5_noquantize'),
t_model('bge-base-en-v1.5.onnx', 'bge_base_en_v1_5'),
t_model('bge-micro-v2.onnx', 'bge_micro_v2'),
t_model('bge-reranker-base.onnx', 'bge_reranker_base'),
t_model('bge-small-en-v1.5.onnx', 'bge_small_en_v1_5'),
t_model('clip-vit-large-patch14_img.onnx', 'clip_vit_large_patch14_img'),
t_model('clip-vit-large-patch14_txt.onnx', 'clip_vit_large_patch14_txt'),
t_model('distiluse-base-multilingual-cased-v2.onnx', 'distiluse_base_multilingual_cased_v2'),
t_model('e5-base-v2.onnx', 'e5_base_v2'),
t_model('e5-small-v2.onnx', 'e5_small_v2'),
t_model('gender-classification.onnx', 'gender_classification'),
t_model('gender-classification-quantize.onnx', 'gender_classification_quantize'),
t_model('gte-base.onnx', 'gte_base'),
t_model('gte-small.onnx', 'gte_small'),
t_model('gte-tiny.onnx', 'gte_tiny'),
t_model('multilingual-e5-base.onnx', 'multilingual_e5_base'),
t_model('multilingual-e5-small.onnx', 'multilingual_e5_small'),
t_model('multi-qa-MiniLM-L6-cos-v1.onnx', 'multi_qa_MiniLM_L6_cos_v1'),
t_model('mxbai-embed-large-v1-noquantize.onnx', 'mxbai_embed_large_v1_noquantize'),
t_model('mxbai-embed-large-v1.onnx', 'mxbai_embed_large_v1'),
t_model('mxbai-embed-xsmall-v1.onnx', 'mxbai_embed_xsmall_v1'),
t_model('nsfw_image_detection.onnx', 'nsfw_image_detection'),
t_model('nsfw_image_detection-quantize.onnx', 'nsfw_image_detection_quantize'),
t_model('paraphrase-multilingual-mpnet-base-v2.onnx', 'paraphrase_multilingual_mpnet_base_v2'),
t_model('resnet-18.onnx', 'resnet_18'),
t_model('resnet-50.onnx', 'resnet_50'),
t_model('snowflake-arctic-embed-m.onnx', 'snowflake_arctic_embed_m'),
t_model('snowflake-arctic-embed-s.onnx', 'snowflake_arctic_embed_s'),
t_model('snowflake-arctic-embed-xs.onnx', 'snowflake_arctic_embed_xs'),
t_model('stsb-xlm-r-multilingual.onnx', 'stsb_xlm_r_multilingual'),
t_model('vit-age-classifier.onnx', 'vit_age_classifier'),
t_model('vit-base-nsfw-detector.onnx', 'vit_base_nsfw_detector'),
t_model('vit-base-patch16-224.onnx', 'vit_base_patch16_224'),
t_model('vit-face-expression.onnx', 'vit_face_expression'),
t_model('vit-small-patch16-224.onnx', 'vit_small_patch16_224'),
t_model('vit-tiny-patch16-224.onnx', 'vit_tiny_patch16_224'),

41 rows selected. 

*/