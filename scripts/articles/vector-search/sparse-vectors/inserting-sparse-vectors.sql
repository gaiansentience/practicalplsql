--inserting-sparse-vectors.sql
column serialized format a25
column notes format a42

drop table if exists sparse_vectors purge;

create table sparse_vectors(
    id integer generated always as identity primary key,
    embedding vector(8, int8, sparse),
    notes varchar2(100)
)
/

begin

    insert into sparse_vectors(
        embedding
        , notes
    ) values (
        '[8,[0,1,4],[1,2,5]]'
        , 'sparse text input with dimension count');
        
    insert into sparse_vectors(
        embedding
        , notes
    ) values (
        '[[0,1,4],[1,2,5]]'
        , 'sparse text input without dimension count');        
    
    insert into sparse_vectors(
        embedding
        , notes
    ) values (
        to_vector('[8,[0,1,4],[1,2,5]]', *, *, sparse)
        , 'constructed sparse vector');
    
    insert into sparse_vectors(
        embedding
        , notes
    ) values (
        to_vector('[1,2,0,0,5,0,0,0]', *, *, dense)
        , 'constructed dense vector');
    
    commit;

end;
/

select
    from_vector(embedding) as serialized
    , notes
from sparse_vectors
/

/*
SERIALIZED                NOTES                                     
------------------------- ------------------------------------------
[8,[0,1,4],[1,2,5]]       sparse text input with dimension count    
[8,[0,1,4],[1,2,5]]       sparse text input without dimension count 
[8,[0,1,4],[1,2,5]]       constructed sparse vector                 
[8,[0,1,4],[1,2,5]]       constructed dense vector  
*/

--dense textual input cannot be directly inserted to a sparse vector column
insert into sparse_vectors(
    embedding
    , notes
) values (
    '[1,2,0,0,5,0,0,0]'
    , 'inserted as dense textual input');
    
--SQL Error: ORA-51833: Textual input conversion between sparse and dense vector is not supported.
