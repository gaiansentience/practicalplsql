--sparse-vector-indexes.sql

create vector index sparse_vectors_ivf 
    on sparse_vectors (embedding) 
    organization neighbor partitions
    distance cosine
    with target accuracy 90;
    
--ORA-51839: Vector index cannot be created on top of SPARSE vector columns.