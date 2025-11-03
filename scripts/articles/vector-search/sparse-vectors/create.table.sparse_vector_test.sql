--create.table.sparse_vector_test.sql

create table sparse_vector_test(
    v_sparse  vector(8, int8, sparse),
    v_dense   vector(8, int8, dense),
    v_default vector(8, int8)
)
/

describe sparse_vector_test;

/*
Name      Null? Type                  
--------- ----- --------------------- 
V_SPARSE        VECTOR(8,INT8,SPARSE) 
V_DENSE         VECTOR(8,INT8,DENSE)  
V_DEFAULT       VECTOR(8,INT8,DENSE)  
*/


drop table sparse_vector_test purge;

