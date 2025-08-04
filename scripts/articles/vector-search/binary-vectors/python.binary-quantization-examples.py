# python.binary-quantization-examples.py
# save in environment set up for sentence transformers and python 3.12
# quantize with sentence transformers to verify dimension ordering
from sentence_transformers import SentenceTransformer
from sentence_transformers.quantization import quantize_embeddings
# use example vectors with dimension values as 0 and 1
embeddings = [
    [0,0,1,0,1,0,1,0],
    [0,0,0,0,1,0,1,1]
    ]
print("input embeddings")
print(embeddings)
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("expected packed binary vectors are [42] and [11]")
print("sentence_transformers.quantization with ubinary precision")
print(embeddings_binary)
embeddings = [
    [0,0,1,0,1,0,1,0,0,0,0,0,1,0,1,1]
    ]
print("input embeddings")
print(embeddings)
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("expected packed binary vector is [42,11]")
print("sentence_transformers.quantization with ubinary precision")
print(embeddings_binary)