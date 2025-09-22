

drop index if exists menu_vectors_e0;

create vector index menu_vectors_e0 on menu_vectors (embedding) 
organization neighbor partitions
distance cosine
with target accuracy 80;

drop index if exists menu_vectors_e1;

create vector index menu_vectors_e1 on menu_vectors (embedding1) 
organization neighbor partitions
distance cosine
with target accuracy 80;

drop index if exists menu_vectors_e2;

create vector index menu_vectors_e2 on menu_vectors (embedding2) 
organization neighbor partitions
distance cosine
with target accuracy 80;

drop index if exists menu_vectors_e3;

create vector index menu_vectors_e3 on menu_vectors (embedding3) 
organization neighbor partitions
distance cosine
with target accuracy 80;


