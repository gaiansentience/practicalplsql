--create.table.recipes_compare.sql
--requires loaded recipes table from examples/sample_foods recipes example

describe recipes;

drop table if exists recipes_compare purge
/

create table recipes_compare as 
select name, doc
from recipes
/

alter table recipes_compare add(
    embedding vector(*, *)
    , embedding_model varchar2(50)
    , embedding1 vector(*, *)
    , embedding1_model varchar2(50)
    , embedding1_binary vector(*, binary)
    , embedding2 vector(*, *)
    , embedding2_model varchar2(50)
    , embedding2_binary vector(*, binary)
)
/

describe recipes_compare;