--load-all-text-onnx-models.sql

@drop-loaded-models.sql;



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
    t_model('snowflake-arctic-embed-xs.onnx', 'snowflake_arctic_embed_xs')
    --t_model('stsb-xlm-r-multilingual.onnx', 'stsb_xlm_r_multilingual') --see below, creates PGA memory error unless loaded separately
    );

dbms_output.put_line('Loading ' || l_models.count || ' onnx models');

for v in values of l_models loop

    dbms_vector.load_onnx_model(l_models_dir, v.onnx_filename, v.model_name);
    
    dbms_output.put_line(v.onnx_filename || ' loaded successfully as ' || v.model_name);
    
end loop;

end;
/

--loading al text models at once generates ORA-040036: PGA Memory used by the instance or PDB exceeds PGA_AGGREGATE_LIMIT
--all models load except for stsb... load it separately
begin
    dbms_vector.load_onnx_model('ML_MODELS_DIR', 'stsb-xlm-r-multilingual.onnx', 'stsb_xlm_r_multilingual');
    dbms_output.put_line('stsb-xlm-r-multilingual.onnx loaded successfully as stsb_xlm_r_multilingual');
end;
/


@list-loaded-models.sql;


/*

PL/SQL procedure successfully completed.

Loading 21 onnx models
all-MiniLM-L12-v2.onnx loaded successfully as all_MiniLM_L12_v2
all-MiniLM-L6-v2.onnx loaded successfully as all_MiniLM_L6_v2
all-mpnet-base-v2.onnx loaded successfully as all_mpnet_base_v2
bge-base-en-v1.5.onnx loaded successfully as bge_base_en_v1_5
bge-micro-v2.onnx loaded successfully as bge_micro_v2
bge-small-en-v1.5.onnx loaded successfully as bge_small_en_v1_5
distiluse-base-multilingual-cased-v2.onnx loaded successfully as distiluse_base_multilingual_cased_v2
e5-base-v2.onnx loaded successfully as e5_base_v2
e5-small-v2.onnx loaded successfully as e5_small_v2
gte-base.onnx loaded successfully as gte_base
gte-small.onnx loaded successfully as gte_small
gte-tiny.onnx loaded successfully as gte_tiny
multilingual-e5-base.onnx loaded successfully as multilingual_e5_base
multilingual-e5-small.onnx loaded successfully as multilingual_e5_small
multi-qa-MiniLM-L6-cos-v1.onnx loaded successfully as multi_qa_MiniLM_L6_cos_v1
mxbai-embed-large-v1.onnx loaded successfully as mxbai_embed_large_v1
mxbai-embed-xsmall-v1.onnx loaded successfully as mxbai_embed_xsmall_v1
paraphrase-multilingual-mpnet-base-v2.onnx loaded successfully as paraphrase_multilingual_mpnet_base_v2
snowflake-arctic-embed-m.onnx loaded successfully as snowflake_arctic_embed_m
snowflake-arctic-embed-s.onnx loaded successfully as snowflake_arctic_embed_s
snowflake-arctic-embed-xs.onnx loaded successfully as snowflake_arctic_embed_xs


PL/SQL procedure successfully completed.

stsb-xlm-r-multilingual.onnx loaded successfully as stsb_xlm_r_multilingual


PL/SQL procedure successfully completed.


MODEL_NAME                               MINING_FUNCTION      ALGORITHM       MODEL_SIZE   MODEL_INPUT          MODEL_EMBEDDING                                                                                                        
---------------------------------------- -------------------- --------------- ------------ -------------------- -----------------------------------------------------------------------------------------------------------------------
ALL_MINILM_L12_V2                        EMBEDDING            ONNX            133,349,965  TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
ALL_MINILM_L6_V2                         EMBEDDING            ONNX            90,636,502   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
ALL_MPNET_BASE_V2                        EMBEDDING            ONNX            109,759,755  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
BGE_BASE_EN_V1_5                         EMBEDDING            ONNX            109,803,972  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
BGE_MICRO_V2                             EMBEDDING            ONNX            34,824,663   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
BGE_SMALL_EN_V1_5                        EMBEDDING            ONNX            133,349,948  TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
DISTILUSE_BASE_MULTILINGUAL_CASED_V2     EMBEDDING            ONNX            136,470,592  TEXT VARCHAR2        VECTOR(512,FLOAT32)                                                                                                    
E5_BASE_V2                               EMBEDDING            ONNX            109,803,970  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
E5_SMALL_V2                              EMBEDDING            ONNX            133,349,946  TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
GTE_BASE                                 EMBEDDING            ONNX            218,386,358  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
GTE_SMALL                                EMBEDDING            ONNX            67,027,335   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
GTE_TINY                                 EMBEDDING            ONNX            45,558,487   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
MULTILINGUAL_E5_BASE                     EMBEDDING            ONNX            283,205,707  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
MULTILINGUAL_E5_SMALL                    EMBEDDING            ONNX            123,080,154  TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
MULTI_QA_MINILM_L6_COS_V1                EMBEDDING            ONNX            90,636,512   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
MXBAI_EMBED_LARGE_V1                     EMBEDDING            ONNX            335,905,910  TEXT VARCHAR2        VECTOR(1024,FLOAT32)                                                                                                   
MXBAI_EMBED_XSMALL_V1                    EMBEDDING            ONNX            24,462,077   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
PARAPHRASE_MULTILINGUAL_MPNET_BASE_V2    EMBEDDING            ONNX            283,205,738  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
SNOWFLAKE_ARCTIC_EMBED_M                 EMBEDDING            ONNX            109,803,985  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    
SNOWFLAKE_ARCTIC_EMBED_S                 EMBEDDING            ONNX            133,349,960  TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
SNOWFLAKE_ARCTIC_EMBED_XS                EMBEDDING            ONNX            90,636,499   TEXT VARCHAR2        VECTOR(384,FLOAT32)                                                                                                    
STSB_XLM_R_MULTILINGUAL                  EMBEDDING            ONNX            283,205,722  TEXT VARCHAR2        VECTOR(768,FLOAT32)                                                                                                    

22 rows selected. 

*/