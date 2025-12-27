set serveroutput on;
declare
    f varchar2(100) := 'splade_v3_distilbert.onnx';
    m varchar2(100) := 'splade_sparse_encoder';
    i number;
begin
    select count(*) into i
    from user_mining_models
    where model_name = upper(m);
    if i > 0 then
        dbms_vector.drop_onnx_model(upper(m),true);
        dbms_output.put_line('Model dropped previous model: ' || m);
    end if;
    
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        f,
        m);
    dbms_output.put_line(
        f || ' loaded successfuly as ' || m);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

select * from user_mining_models;

with base as (
select 
    vector_dims(v) as dim_count, vector_dimension_format(v) as dim_fmt,
    json(from_vector(v returning clob format dense)) as jvec
from
(
select vector_embedding(SPLADE_SPARSE_ENCODER using 'the sky is blue today' as data) as v
)
)
select j.dim#, j.dim_val
from base b,
json_table(b.jvec, '$[*]' columns(dim# for ordinality,dim_val  number path '$')
) j
order by j.dim_val
/


with base(txt) as (
    values 
        ('the atmosphere is a deep azure this morning')
        , ('the turquoise sky is dotted with silver clouds')
        , ('the night sky was almost black velvet')
        , ('the clouds reflected in the lake look like dragons')
        , ('the fire is quite warm now')
        , ('it rained all day')
        , ('peanut butter sandwiches would be good for lunch')
        , ('these roses are such a pretty shade of pink')
        , ('the frogs are eating the flies')
        , ('the heavens appeared steel blue today')
), query_vector as (
    select qtxt, vector_embedding(SPLADE_SPARSE_ENCODER using qtxt as data) as qv
    from (
        select 'looking up, she only saw blue up to the heavens' as qtxt)
), base_vectors as (
    select
        txt
        , vector_embedding(SPLADE_SPARSE_ENCODER using txt as data) as v
    from base
)
select b.txt
from base_vectors b
cross join query_vector q
order by vector_distance(q.qv, b.v, cosine)
--order by vector_distance(
--    vector_embedding(SPLADE_SPARSE_ENCODER using 'looking up, she only saw blue sky' as data)
--    , v, cosine)
/

select * from menu_vectors;

select * from user_mining_models;

select * from user_mining_model_attributes order by model_name, attribute_name;