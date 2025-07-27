--loading models in OCI:
--
--URI:
--URL Path (URI):
-- 
--https://objectstorage.us-ashburn-1.oraclecloud.com/n/idjv1ptikjf5/b/adw_ext_data/o/onnx%2Fall-MiniLM-L12-v2.onnx
--
--dedicated URL:
--
--https://idjv1ptikjf5.objectstorage.us-ashburn-1.oci.customer-oci.com/n/idjv1ptikjf5/b/adw_ext_data/o/onnx%2Fall-MiniLM-L12-v2.onnx
--grant create mining model to practicalplsql;

declare
l_model varchar2(100);
l_credential varchar2(100);
l_uri varchar2(4000);
l_onnx_filename varchar2(100);
l_metadata json;

begin

l_credential := '"OCI$RESOURCE_PRINCIPAL"';

--current url syntax
--l_uri := 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idjv1ptikjf5/b/adw_ext_data/o/onnx%2F';

--dedicated url syntax
l_uri := 'https://idjv1ptikjf5.objectstorage.us-ashburn-1.oci.customer-oci.com/n/idjv1ptikjf5/b/adw_ext_data/o/onnx%2F';


l_onnx_filename := 'snowflake-arctic-embed-m.onnx';
l_model := replace(replace(l_onnx_filename, '.onnx'),'-','_');

l_metadata := JSON('{"function" : "embedding", "embeddingOutput" : "embedding", "input": {"input":["DATA"]}}');


DBMS_VECTOR.LOAD_ONNX_MODEL_CLOUD (
     model_name => l_model,
     credential => l_credential,
     uri  => l_uri || l_onnx_filename,     
     metadata => l_metadata);

end;
/