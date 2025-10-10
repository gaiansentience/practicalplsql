

drop index if exists menu_vectors_eb0;

create vector index menu_vectors_eb0 on menu_vectors (embedding_binary) 
organization neighbor partitions
distance hamming
with target accuracy 80;

drop index if exists menu_vectors_eb1;

create vector index menu_vectors_eb1 on menu_vectors (embedding1_binary) 
organization neighbor partitions
distance hamming
with target accuracy 80;


