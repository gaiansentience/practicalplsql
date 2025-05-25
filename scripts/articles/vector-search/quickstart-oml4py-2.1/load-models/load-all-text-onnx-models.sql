set serveroutput on;

declare
    l_models_dir varchar2(50) := 'ML_MODELS_DIR';
    type t_model is record(onnx_filename varchar2(100), model_name varchar2(100));
    type t_models is table of t_model;
    l_models t_models := t_models();

begin

l_models := t_models(
    t_model('all-MiniLM-L12-v2.onnx', 'all_MiniLM_L12_v2'),
    t_model('all-MiniLM-L6-v2.onnx', 'all_MiniLM_L6_v2'),
    t_model('all-mpnet-base-v2.onnx', 'all_mpnet_base_v2'),
    t_model('bge-base-en-v1.5.onnx', 'bge_base_en_v1_5'),
    t_model('bge-micro-v2.onnx', 'bge_micro_v2'),
    t_model('bge-small-en-v1.5.onnx', 'bge_small_en_v1_5'),
    t_model('distiluse-base-multilingual-cased-v2.onnx', 'distiluse_base_multilingual_cased_v2'),
    t_model('e5-base-v2.onnx', 'e5_base_v2'),
    t_model('e5-small-v2.onnx', 'e5_small_v2'),
    t_model('gte-base.onnx', 'gte_base'),
    t_model('gte-small.onnx', 'gte_small'),
    t_model('gte-tiny.onnx', 'gte_tiny'),
    t_model('multilingual-e5-base.onnx', 'multilingual_e5_base'),
    t_model('multilingual-e5-small.onnx', 'multilingual_e5_small'),
    t_model('multi-qa-MiniLM-L6-cos-v1.onnx', 'multi_qa_MiniLM_L6_cos_v1'),
    t_model('mxbai-embed-large-v1.onnx', 'mxbai_embed_large_v1'),
    t_model('mxbai-embed-xsmall-v1.onnx', 'mxbai_embed_xsmall_v1'),
    t_model('paraphrase-multilingual-mpnet-base-v2.onnx', 'paraphrase_multilingual_mpnet_base_v2'),
    t_model('snowflake-arctic-embed-m.onnx', 'snowflake_arctic_embed_m'),
    t_model('snowflake-arctic-embed-s.onnx', 'snowflake_arctic_embed_s'),
    t_model('snowflake-arctic-embed-xs.onnx', 'snowflake_arctic_embed_xs'),
    t_model('stsb-xlm-r-multilingual.onnx', 'stsb_xlm_r_multilingual')
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