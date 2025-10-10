--load.models.all_miniLM.sql
--requires procedure load_onnx_model
@create.procedure.load_onnx_model.local.sql

set serveroutput on;
begin
    load_onnx_model('all-MiniLM-L6-v2.onnx', 'all_MiniLM_L6_v2');    
    load_onnx_model('all-MiniLM-L12-v2.onnx', 'all_MiniLM_L12_v2');
end;
/

/* SCRIPT OUTPUT
Loaded ONNX Model all_MiniLM_L6_v2
Model generates VECTOR(384,FLOAT32)

Loaded ONNX Model all_MiniLM_L12_v2
Model generates VECTOR(384,FLOAT32)
*/

