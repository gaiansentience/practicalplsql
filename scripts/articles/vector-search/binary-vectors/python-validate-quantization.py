
# compare quantization with scalar macro to quantization with sentence transformers
# set up python 3.12 environment
# use pip install sentence_transformers
#
# load Sentence Transformers
from sentence_transformers import SentenceTransformer
from sentence_transformers.quantization import quantize_embeddings
    
#
# vector quantized with macro in database
# dimensions: 8 format: FLOAT32
# [-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0]
print("vector quantized with scalar macro: [42]")
# quantize same vector in sentence transformers:
embeddings = [[-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0]]
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("same vector quantized in python:", embeddings_binary)
#
#
# vector quantized with macro in database
# dimensions: 16 format: FLOAT32
# [-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,2.19999999E-001]
print("vector quantized with scalar macro: [42,11]")
# quantize same vector in sentence transformers:
embeddings = [[-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,2.19999999E-001]]
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("same vector quantized in python:", embeddings_binary)
#
#
# vector quantized with macro in database
# dimensions: 24 format: FLOAT32
# [-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,0,1.19999997E-001,3.30000013E-001,5.60000002E-001,-7.69999981E-001,8.79999995E-001,-9.9000001E-001,2.09999993E-001,4.19999987E-001]
print("vector quantized with scalar macro: [42,10,235]")
# quantize same vector in sentence transformers:
embeddings = [[-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,0,1.19999997E-001,3.30000013E-001,5.60000002E-001,-7.69999981E-001,8.79999995E-001,-9.9000001E-001,2.09999993E-001,4.19999987E-001]]
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("same vector quantized in python:", embeddings_binary)
#
#
# vector quantized with macro in database
# dimensions: 32 format: FLOAT32
# [-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,0,1.19999997E-001,-3.30000013E-001,5.60000002E-001,7.69999981E-001,8.79999995E-001,-9.9000001E-001,2.09999993E-001,-4.19999987E-001,-5.0999999E-001,-6.10000014E-001,7.09999979E-001,8.10000002E-001,-9.10000026E-001,-1.00999999E+000,1.29999995E-001,2.30000004E-001]
print("vector quantized with scalar macro: [42,10,186,51]")
# quantize same vector in sentence transformers:
embeddings = [[-1.23000003E-001,-6.53999984E-001,3.44999999E-001,-1.99999996E-002,7.88999975E-001,-5.66999972E-001,8.88000011E-001,0,-1.23000003E-001,-4.44000006E-001,-6.49999976E-001,-1.99999996E-002,2.31000006E-001,-1.09999999E-001,7.30000019E-001,0,1.19999997E-001,-3.30000013E-001,5.60000002E-001,7.69999981E-001,8.79999995E-001,-9.9000001E-001,2.09999993E-001,-4.19999987E-001,-5.0999999E-001,-6.10000014E-001,7.09999979E-001,8.10000002E-001,-9.10000026E-001,-1.00999999E+000,1.29999995E-001,2.30000004E-001]]
embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")
print("same vector quantized in python:", embeddings_binary)
#

