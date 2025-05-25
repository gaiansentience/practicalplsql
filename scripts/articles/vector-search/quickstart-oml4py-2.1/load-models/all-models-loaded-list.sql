--loading-models-list.sql
set pagesize 100
 column model_name format a40
 column mining_function format a20
 column algorithm format a10
 column algorithm_type format a15
 column model_size format 999,999,999
 column model_attributes format a30



select model_name, mining_function, algorithm, algorithm_type, to_char(model_size,'fm9,999,999,999') as model_size
    , ( select vector_info
        from user_mining_model_attributes a
        where a.model_name = m.model_name and a.attribute_name = 'ORA$ONNXTARGET' and a.attribute_type = 'VECTOR'
        ) as model_attributes
from user_mining_models m
order by model_name;
















