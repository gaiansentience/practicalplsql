--sanity check of binary representation in oracle compared to using sentence transformers in Python

/*
cd /home/oracle/oml4py
source ./setPython3Env.sh

cd /home/oracle/python
# add sentence-transformers package to python installation
python3 -m pip install -U sentence-transformers
# open python environment
python3


# import sentence_transformers
from sentence_transformers mport SentenceTransformer
from sentence_transformers.quantization import quantize_embedddings
# load the embedding model
model = SentenceTransformer("mixedbread-ai/mxbai-embed-xsmall-v1")
#encode search term
embeddings = model.encode(["healthy dinner"])
binary_embeddings = quantize_embeddings(embeddings, precision="ubinary")
print(binary_embeddings)

-->>> embeddings = model.encode(["healthy dinner"])
-->>> binary_embeddings = quantize_embeddings(embeddings, precision = "ubinary")
-->>> print(binary_embeddings)
--[[212  34 135 227 200  49 215  28  20 169 121 153  30 123 200  83  42 174
--   82 123   5 247  13 220  67 192 244 201 216 235 247 114 177 212  99 101
--  140  81  32 110 146 221 219 246  98  29  89 236]]

*/

--back in Oracle, with the same model loaded 
select to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data));
-- [214, 34,134,227,200, 49,215, 28, 21,185,123,149, 31, 91,200, 67, 42,174
--  ,83,111,  5,255,  8,220, 71,192,244,201,216,219,255,114,177,212, 99,165
-- ,205, 81, 32, 78,146,220,155,246, 98, 93, 89,236]

/* text input, embedding in python, embedding in database
'healthy dinner'
[212  34 *135 227 200  49 215  28  *20 *169 *121 *153  *30 *123 200  *83  42 174  82 *123   5 *247  *13 220  *67 192 244 201 216 *235 *247 114 177 212  99 *101 *140  81  32 *110 146 *221 *219 246  98  *29  89 236]
[214, 34,*134,227,200, 49,215, 28, *21,*185,*123,*149, *31, *91,200, *67, 42,174, 83,*111,  5,*255,  *8,220, *71,192,244,201,216,*219,*255,114,177,212, 99,*165,*205, 81, 32, *78,146,*220,*155,246, 98, *93, 89,236]
*/

select to_binary_vector(to_vector('[0,0,1,0,1,0,1,0]',8,int8));
/*
--confirm that 00101010 should be converted to 42 in uint packed vector
>>> from sentence_transformers import SentenceTransformer
>>> from sentence_transformers.quantization import quantize_embeddings
>>> embeddings = [[0,0,1,0,1,0,1,0]]
>>> binary_embeddings = quantize_embeddings(embeddings, precision="ubinary")
>>> print(embeddings)
[[0, 0, 1, 0, 1, 0, 1, 0]]
>>> print(binary_embeddings)
[[42]]

>>> embeddings =[[0,0,1,0,1,0,1,0 ,0,0,1,0,1,0,1,0]]
>>> binary_embeddings = quantize_embeddings(embeddings, precision="ubinary")
>>> print(embeddings)
[[0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0]]
>>> print(binary_embeddings)
[[42 42]]
>>> 
*/


/*
>>> 
>>> from sentence_transformers import SentenceTransformer
>>> from sentence_transformers.quantization import quantize_embeddings
>>> model = SentenceTransformer("mixedbread-ai/mxbai-embed-xsmall-v1")
>>> #encode text without quantization and then apply quantization
>>> embeddings = model.encode(["I am driving to the lake.", "It is a beautiful day.", "A healthy dinner would be good."])
>>> binary_embeddings = quantize_embeddings(embeddings, precision="ubinary")
>>> print(binary_embeddings)
[
[187 103 133  84   2 185 193 113  15  14  59 193  62 218 223  57 188 130  192 12 113   3   5 166 218 249  88 217 171 222 215 209 155 183 102 149  128 110 218 116 219  43 131 185   3 119  77 152]
[242 153  21 105 155  48 147 165 165 211 181 132  93 147 247  59 120   2  113 46 233   7 136 104 124 187 108  89 209 126 214 208  25  57 222  17  148  47 112  68  10 119 233 199  74 239  92 124]
[116  34 150 103  88 227 211  23 149 139 119  29  31  81 216 123 124 142  211 41   5 243   8 196  83 211 221 192 216  91 247  84 185 212 103  37  133 211  32 206 146 220 155 254  98  25 121 228]
]
>>> 

*/

with base(text) as (
values('I am driving to the lake.'), ('It is a beautiful day.'), ('A healthy dinner would be good.')
)
select to_binary_vector(vector_embedding(mxbai_embed_xsmall_v1 using b.text as data)) as indb_binary_embeddings
from base b

/*
[191, 34,197, 68,  2,185,193, 85, 13,142, 63,197, 60,218,219, 49,188,130, 66,140,113,  3, 65,165, 90,241,216,217,170,222,215,209,157,183,102,149,144,230,218, 84,243, 47,145,249, 19,126, 77,152]
[242,139, 21, 97,155, 56,211,183,129,211,181,132, 95,147,241, 59,248,  2,117,111,237, 15,200,120,126,187,108, 73,209,122,212,220, 25, 59, 30, 17,148, 47,112, 84, 34,103,251,151, 82,250, 92,124]
[112, 34,150, 99,200,161,211, 23,148,147,115,159, 31, 83,216,123, 60,142, 83, 41,  5,243,  8,204, 71,211,220,217,216,251,255, 84,185,214, 99,165,141,219, 41,206,146,221,155,246, 98, 89, 89,236]
*/


/*
--sentence, embedding generated in python, embedding generated in database
"I am driving to the lake."
[187 103 133  84   2 185 193 113  15  14  59 193  62 218 223  57 188 130 192  12 113   3   5 166 218 249  88 217 171 222 215 209 155 183 102 149 128 110 218 116 219  43 131 185   3 119  77 152]
[191, 34,197, 68,  2,185,193, 85, 13,142, 63,197, 60,218,219, 49,188,130, 66,140,113,  3, 65,165, 90,241,216,217,170,222,215,209,157,183,102,149,144,230,218, 84,243, 47,145,249, 19,126, 77,152]

"It is a beautiful day."
[242 153  21 105 155  48 147 165 165 211 181 132  93 147 247  59 120   2 113  46 233   7 136 104 124 187 108  89 209 126 214 208  25  57 222  17 148  47 112  68  10 119 233 199  74 239  92 124]
[242,139, 21, 97,155, 56,211,183,129,211,181,132, 95,147,241, 59,248,  2,117,111,237, 15,200,120,126,187,108, 73,209,122,212,220, 25, 59, 30, 17,148, 47,112, 84, 34,103,251,151, 82,250, 92,124]


"A healthy dinner would be good."
[116  34 150 103  88 227 211  23 149 139 119  29  31  81 216 123 124 142 211  41   5 243   8 196  83 211 221 192 216  91 247  84 185 212 103  37  133 211  32 206 146 220 155 254  98  25 121 228]
[112, 34,150, 99,200,161,211, 23,148,147,115,159, 31, 83,216,123, 60,142, 83, 41,  5,243,  8,204, 71,211,220,217,216,251,255, 84,185,214, 99,165,141,219, 41,206,146,221,155,246, 98, 89, 89,236]
*/

