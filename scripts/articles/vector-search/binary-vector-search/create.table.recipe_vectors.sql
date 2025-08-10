--create.table.recipe_vectors.sql
--requires loaded recipes table from examples/sample_foods recipes example

describe recipes;

drop table if exists recipe_vectors purge
/

create table recipe_vectors as 
select name, doc
from recipes
/

alter table recipe_vectors add(
    embedding vector(*,*)
    , embedding_model varchar2(50)
    , embedding_binary vector(*, binary)    
)
/

describe recipe_vectors;