--load-models\load-all_miniLM_l6_v2.sql
column model_name format a18
column mining_function format a15
column algorithm format a10
column algorithm_type format a15
column attribute_name format a15
column attribute_type format a15
column data_type format a10
column vector_info format a20


begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'all_MiniLM_L6_v2.onnx',
    'all_minilm_l6_v2');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'ALL_MINILM_L6_V2'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'ALL_MINILM_L6_V2'
ORDER BY attribute_name;


/*
MODEL_NAME         MINING_FUNCTION ALGORITHM  ALGORITHM_TYPE  MODEL_SIZE
------------------ --------------- ---------- --------------- ----------
ALL_MINILM_L6_V2   EMBEDDING       ONNX       NATIVE            90621438

MODEL_NAME         ATTRIBUTE_NAME  ATTRIBUTE_TYPE  DATA_TYPE  VECTOR_INFO         
------------------ --------------- --------------- ---------- --------------------
ALL_MINILM_L6_V2   DATA            TEXT            VARCHAR2                       
ALL_MINILM_L6_V2   ORA$ONNXTARGET  VECTOR          VECTOR     VECTOR(384,FLOAT32) 
*/