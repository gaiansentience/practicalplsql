

#convert splade model to onnx format for importing

#this model creates following error
#ValueError: 
#Provided model prithivida/Splade_PP_en_v2 does not have a safetensors version. 
#If you want to forcefully use a model without safetensors, 
#set ignore_safetensors_error to True in the settings.
#this works for model export...loading to oracle still returns dense vectors


$ python3

from oml.utils import ONNXPipeline, ONNXPipelineConfig
m = 'prithivida/Splade_PP_en_v2'
f = 'splade_PP_en_v2'
c = ONNXPipelineConfig.from_template("text", max_seq_length=256, distance_metrics=["COSINE","DOT"], quantize_model=True)
pipeline = ONNXPipeline(model_name=m, config=c, settings={"force_download":True,"ignore_safetensors_error":True})
pipeline.export2file(f, output_dir=".")


$ python3



from oml.utils import ONNXPipeline, ONNXPipelineConfig
m = 'naver/splade-v3-distilbert'
f = 'splade_v3_distilbert'
c = ONNXPipelineConfig.from_template("text", max_seq_length=256, distance_metrics=["COSINE","DOT"], quantize_model=True)
#pipeline = ONNXPipeline(model_name=m, config=c, settings={"force_download":True})
pipeline = ONNXPipeline(model_name=m, config=c, settings={"force_download":True,"ignore_safetensors_error":True})
pipeline.export2file(f, output_dir=".")


from oml.utils import ONNXPipeline, ONNXPipelineConfig
from transformers import AutoTokenizer
m = 'naver/splade-v3-distilbert'
f = 'splade_v3_distilbert'
tokenizer=AutoTokenizer.from_pretrained(m)
c = ONNXPipelineConfig.from_template("text", max_seq_length=256, distance_metrics=["COSINE","DOT"], quantize_model=True)
#pipeline = ONNXPipeline(model_name=m, config=c, settings={"force_download":True})
pipeline = ONNXPipeline(model_name=m, config=c, settings={"force_download":True,"ignore_safetensors_error":True})
pipeline.export2file(f, output_dir=".")


import oml.utils as utils
from transformers import AutoTokenizer

# 1. Load your SPLADE model and tokenizer from Hugging Face or local path
model_name = "naver/splade-cobert-ved" # Example SPLADE model name
tokenizer = AutoTokenizer.from_pretrained(model_name)

# 2. Define the configuration for ONNX export
# OML4Py provides built-in templates for common model types
# A SPLADE model is a text embedding/transformer model
onnx_config = utils.AutoONNXConfig.from_pretrained(
    model_name,
    # Example: specify the task type if needed
    task="text-embedding" 
)

# 3. Export the model to a local ONNX file or directly to the database
# Export to a local file first is a common approach
onnx_model_path = "./splade_model.onnx"
utils.export_onnx_pipeline(
    model_name,
    onnx_model_path,
    tokenizer=tokenizer,
    onnx_config=onnx_config,
    # Additional parameters may be needed depending on the specific SPLADE variant
)