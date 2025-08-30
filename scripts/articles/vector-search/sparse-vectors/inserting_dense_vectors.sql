


create table dense_vectors(
    id integer generated always as identity primary key,
    vec vector(*, *, dense),
    notes varchar2(200)
)
/

--determine the sparse textual format for a dense vector
with base as (
    select to_vector('[1,2,0,0,5,6,0,0]', 8, int8, dense) as v_dense
)
select 
    from_vector(v_dense returning clob format dense) as serialize_v_dense
    , from_vector(v_dense returning clob format sparse) as serialize_v_sparse
from base;


--insert using dense textual input directly (results in default float32 dimension format
insert into dense_vectors(vec, notes)
values ('[1,2,0,0,5,6,0,0]', 'insert dense textual input uses default dimension format of float32');


--construct the vector using dense format and insert to the dense vector column
insert into dense_vectors(vec, notes)
values (
    to_vector('[1,2,0,0,5,6,0,0]', 8, int8, dense)
    , 'insert constructed int8 dense vector'
    );

--insert directly using sparse textual input fails
insert into dense_vectors(vec, notes)
values ('[8,[0,1,4,5],[1,2,5,6]]', 'insert fails with sparse textual input');
--ORA-51833: Textual input conversion between sparse and dense vector is not supported.


--construct vector from sparse textual input and insert
insert into dense_vectors(vec, notes)
values (
    to_vector('[8,[0,1,4,5],[1,2,5,6]]', 8, int8, sparse)
    , 'insert constructed int8 sparse vector (default float32 in 23.7)'
    );

--construct a sparse vector, then use it to construct a dense vector
insert into dense_vectors(vec, notes)
values (
    to_vector(
        to_vector('[8,[0,1,4,5],[1,2,5,6]]', 8, int8, sparse)
        ,8,int8,dense
        )
    , 'use vector constructor again to set dimension format from constructed sparse vector'
    );

commit;

select * from dense_vectors;

drop table dense_vectors purge;