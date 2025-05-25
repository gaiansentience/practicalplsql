
declare

cursor c is
select model_name, mining_function, algorithm, algorithm_type, to_char(model_size,'fm9,999,999,999') as model_size
    , ( select vector_info
        from user_mining_model_attributes a
        where a.model_name = m.model_name and a.attribute_name = 'ORA$ONNXTARGET' and a.attribute_type = 'VECTOR'
        ) as model_attributes
from user_mining_models m
order by model_name;

begin

for r in c loop

    dbms_vector.drop_onnx_model(r.model_name, true);
    
end loop;

end;
/

