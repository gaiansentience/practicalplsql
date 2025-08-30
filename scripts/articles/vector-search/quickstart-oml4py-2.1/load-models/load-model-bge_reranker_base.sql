
--load-model-bge_reranker_base.sql    
    
begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'bge-reranker-base.onnx',
        'bge_reranker_base', 
        JSON('
            {
            "function":"regression",
            "regressionOutput":"logits",
            "input":{
                "first_input":["DATA1"],
                "second_input":["DATA2"]
                }
            }
            ')
        );
end;
/
/*
ERROR at line 1:
ORA-54413: Cannot find model output "logits", specified by "regressionOutput"
ORA-06512: at "SYS.DBMS_VECTOR", line 2150
ORA-06512: at "SYS.DBMS_DATA_MINING", line 5767
ORA-06512: at "SYS.DBMS_VECTOR", line 2145
*/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'BGE_RERANKER_BASE'
order by model_name
/ 


select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'BGE_RERANKER_BASE'
order by attribute_name
/

    
