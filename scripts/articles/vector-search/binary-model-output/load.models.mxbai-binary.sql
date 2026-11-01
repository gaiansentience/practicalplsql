

--load.models.mxbai-binary.sql
--requires procedure load_onnx_model
@create.procedure.load_onnx_model.local.sql


--load onnx mxbai models with post processor to generate ubinary outputs

set serveroutput on;
begin
    load_onnx_model('mxbai-embed-large-v1-binary.onnx', 'mxbai_embed_large_v1_binary');    
    load_onnx_model('mxbai-embed-xsmall-v1-binary.onnx', 'mxbai_embed_xsmall_v1_binary');
end;
/

/* SCRIPT OUTPUT
ORA-54443: Invalid tensor element data type for an embedding output: "embedding"

ORA-54443: Invalid tensor element data type for an embedding output: "embedding"
*/