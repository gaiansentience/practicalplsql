import sentence_transformers
import array
import oracledb
from sentence_transformers import SparseEncoder

def convert_tensor_to_ora_sparse_vector(inputTensor):
     """Convert torch tensor to oracledb.SparseVector"""
     # Convert torch tensor to oracledb.SparseVector by isolating indices and values
     # Coalesce the tensor first to merge duplicate indices
     t = inputTensor.coalesce()
     num_dimensions = t.size(1) # Assuming 2D, using the second dimension for vector size
     indices = t.indices()[1].tolist() # Get column indices
     values = t.values().tolist()
     
     return oracledb.SparseVector(
          num_dimensions,
          indices,
          array.array('f', values) 
     )

def encode_sentence_to_tensor(sentence_text, model, debug=False):
     """Encode a sentence to sparse tensor representation"""
     sentence = [sentence_text]
     # Encode the sentence to get sparse representation as a pytorch tensor
     t = model.encode(sentence)
     if debug:
          print(f"\nEncoding sentence: {sentence_text}")
          print(f"\n  Encoded tensor shape: {t.shape}")
          print(f"  Encoded tensor details:\n {t}")
     return t

def encode_sentence_to_vector(sentence_text, model, debug=False):
     """Encode a sentence to oracledb.SparseVector representation using splade model that produces tensor output"""
     t = encode_sentence_to_tensor(sentence_text, model, debug=debug)
     v = convert_tensor_to_ora_sparse_vector(t)
     if debug:
          print_ora_sparse_vector_info(v)
     return v

def print_ora_sparse_vector_info(sparse_vector):
     """Print information about an oracledb.SparseVector"""
     print("\nOracle Sparse Vector Details:")
     print(f"  Dimensions: {sparse_vector.num_dimensions}")
     print(f"  Indices: {sparse_vector.indices}")
     print(f"  Values: {sparse_vector.values}")
     print(f"  Print the oracle sparse vector:\n {sparse_vector}")