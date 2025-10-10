--load.models.mxbai.sql
--requires procedure load_onnx_model
@create.procedure.load_onnx_model.local.sql

set serveroutput on;
begin
    load_onnx_model('mxbai-embed-large-v1.onnx', 'mxbai_embed_large_v1');    
    load_onnx_model('mxbai-embed-xsmall-v1.onnx', 'mxbai_embed_xsmall_v1');
end;
/

/* SCRIPT OUTPUT
Loaded ONNX Model mxbai_embed_large_v1
Model generates VECTOR(1024,FLOAT32)

Loaded ONNX Model mxbai_embed_xsmall_v1
Model generates VECTOR(384,FLOAT32)
*/