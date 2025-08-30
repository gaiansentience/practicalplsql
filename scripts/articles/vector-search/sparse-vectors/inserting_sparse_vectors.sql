

create table sparse_vectors(
    id integer generated always as identity primary key,
    vec vector(*, *, sparse),
    notes varchar2(200)
)
/

--determine the sparse textual format for a dense vector
with base as (
select to_vector('[1,2,0,0,5,6,0,0]',8,int8,dense) as v_dense
)
select 
    from_vector(v_dense returning clob format dense) as serialize_v_dense
    , from_vector(v_dense returning clob format sparse) as serialize_v_sparse
from base;

--construct vector from sparse textual input and insert
insert into sparse_vectors(vec, notes)
values (
    to_vector('[8,[0,1,4,5],[1,2,5,6]]',8,int8,sparse)
    , 'inseert constructed int8 sparse vector'
    );

--insert directly using sparse textual input
insert into sparse_vectors(vec, notes)
values (
    '[8,[0,1,4,5],[1,2,5,6]]'
    , 'insert with sparse textual input uses default dimension format of float32'
    );

--insert using dense textual input fails
insert into sparse_vectors(vec, notes)
values ('[1,2,0,0,5,6,0,0]', 'insert dense textual input fails');
--ORA-51833: Textual input conversion between sparse and dense vector is not supported.

--construct the vector using dense format and insert to the sparse vector column
insert into sparse_vectors(vec, notes)
values (
    to_vector('[1,2,0,0,5,6,0,0]',8,int8,dense)
    , 'construct int8 dense vector and insert to sparse vector (becomes float32 in 23.7)'
    );

--construct a dense vector, then use it to construct a sparse vector
insert into sparse_vectors(vec, notes)
values (
    to_vector(
        to_vector('[1,2,0,0,5,6,0,0]',8,int8,dense)
        ,8,int8,sparse
        )
        , 'construct int8 dense vector and use it to construct int8 sparse vector'
    );

select * from sparse_vectors;

drop table sparse_vectors purge;