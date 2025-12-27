from sparse_embedding_functions import encode_sentence_to_vector, print_ora_sparse_vector_info
from sentence_transformers import SparseEncoder
import oracledb

# Initialize model
# citation: Damodaran, P. (2024). Splade_PP_en_v2: Independent Implementation of SPLADE++ Model (`a.k.a splade-cocondenser* and family`) for the Industry setting. (Version 2.0.0) [Computer software].
model = SparseEncoder("prithivida/Splade_PP_en_v2")

s = "The sky is blue like an orange."
v = encode_sentence_to_vector(s, model, debug=False)

s = "Many species of sea turtles are currently endangered."
v = encode_sentence_to_vector(s, model, debug=False)

s = "Modern data centers are becoming primary power consumers in the world because of artificial intelligence."
v = encode_sentence_to_vector(s, model, debug=False)

s = "Lithium mining has significant environmental impacts, including habitat destruction and water pollution."
v = encode_sentence_to_vector(s, model, debug=False)

s = "Sustainable resources like solar energy should be evaluated by looking at the entire supply chain and lifecycle of the product."
v = encode_sentence_to_vector(s, model, debug=True)