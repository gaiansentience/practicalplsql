select * from user_tables;



describe menU_vectors;


create vector index menu_vectors_e0 on menu_vectors (embedding) 
organization neighbor partitions
distance cosine
with target accuracy 80;



create vector index menu_vectors_eb0 on menu_vectors (embedding_binary) 
organization neighbor partitions
distance jaccard
with target accuracy 80;

create vector index menu_vectors_e1 on menu_vectors (embedding1) 
organization neighbor partitions
distance cosine
with target accuracy 80;

create vector index menu_vectors_eb1_jaccard on menu_vectors (embedding1_binary) 
organization neighbor partitions
distance jaccard
with target accuracy 80;

alter index menu_vectors_eb1_jaccard visible;

create vector index menu_vectors_eb1_hamming on menu_vectors (embedding1_binary) 
organization neighbor partitions
distance hamming
with target accuracy 80;

select sum(bytes) over () /1024/1024 as sum_mb, s.bytes/1024 as kb, s.bytes/1024/1024 as mb, s.* 
from user_segments s
where segment_name like 'VECTOR$MENU_VECTORS_E0%';

select sum(bytes) over () /1024/1024 as sum_mb, s.bytes/1024 as kb, s.bytes/1024/1024 as mb, s.* 
from user_segments s
where segment_name like 'VECTOR$MENU_VECTORS_EB0%';

select sum(bytes) over () /1024/1024 as sum_mb, s.bytes/1024 as kb, s.bytes/1024/1024 as mb, s.* 
from user_segments s
where segment_name like 'VECTOR$MENU_VECTORS_E1%';

select sum(bytes) over () /1024/1024 as sum_mb, s.bytes/1024 as kb, s.bytes/1024/1024 as mb, s.* 
from user_segments s
where segment_name like 'VECTOR$MENU_VECTORS_EB1%';

select sum(bytes) /1024/1024 as mb
from user_segments s
where segment_name like 'MENU_VECTORS';

select embedding_model from menu_vectors;