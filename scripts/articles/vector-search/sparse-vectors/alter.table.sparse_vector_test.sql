--alter.table.sparse_vector_test.sql

alter table sparse_vector_test
modify v_dense vector(8, int8, sparse);

--ORA-51859: Unsupported VECTOR column modification.

alter table sparse_vector_test
modify v_sparse vector(8, int8, dense);

--ORA-51859: Unsupported VECTOR column modification.