column model_name format a40
column mining_function format a20
column algorithm format a15
column model_input format a20
set pagesize 100

with base as (
select 
    m.model_name, m.mining_function, m.algorithm, to_char(m.model_size, 'fm999,999,999') as model_size, a.attribute_name
    --, attribute_type
    , case a.attribute_type 
        when 'VECTOR' then a.vector_info 
        else a.attribute_type || ' ' || a.data_type 
        end as attribute_detail
    --data_type, vector_info
from 
    user_mining_models m
    join user_mining_model_attributes a on m.model_name = a.model_name
where m.mining_function = 'EMBEDDING' and m.algorithm = 'ONNX'
)
select model_name, mining_function, algorithm, model_size, model_input, model_embedding
from 
    base
    pivot (
        max(attribute_detail) for attribute_name in ('DATA' as model_input, 'ORA$ONNXTARGET' as model_embedding)
    )
order by model_name
/