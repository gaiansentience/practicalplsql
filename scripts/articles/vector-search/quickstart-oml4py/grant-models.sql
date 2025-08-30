


--grant create any synonym to see if private synonyms work
grant create any synonym to dev_vector;

--grant the dev_vector user privileges to create/drop public synonyms
grant create public synonym to dev_vector;
grant drop public synonym to dev_vector;



grant select on mining model dev_vector.ALL_MINILM_L12_V2 to practicalplsql;

grant select on mining model dev_vector.ALL_MINILM_L6_V2 to practicalplsql;

create  synonym practicalplsql.ALL_MINILM_L12_V2 for dev_vector.ALL_MINILM_L12_V2;

create  synonym practicalplsql.ALL_MINILM_L6_V2 for dev_vector.ALL_MINILM_L6_V2;



declare
    l_user varchar2(100) := 'practicalplsql';
    cursor c is
    select owner, model_name
    from all_embedding_models;
begin
    for r in c loop
        execute immediate 'grant select on mining model ' || r.owner || '.' || r.model_name || ' to ' || l_user;
        execute immediate 'create or replace synonym ' || l_user || '.' || r.model_name || ' for ' || r.owner || '.' || r.model_name;
    end loop;
end;
/