prompt create embeddings using mxbai-large llm

set serveroutput on;
declare
    l_start timestamp := localtimestamp;
    l_model varchar2(100);
begin

    update recipes
    set 
        embedding = vector_embedding(MXBAI_EMBED_LARGE_V1 using doc as data),
        embedding_model = 'MXBAI_EMBED_LARGE_V1';
        
    commit;
    
    select distinct 
        embedding_model || ' ('
        || vector_dimension_count(embedding) || ' dimensions, '
        || vector_dimension_format(embedding) || ') '
    into l_model
    from recipes;
    
    dbms_output.put_line('Created embeddings using ' || l_model || to_char(localtimestamp - l_start));
    
end;
/

begin

    dbms_output.put_line('Run Test Vector Search Using ''healthy dinner'' showing top 3 results:');
    
    for r in (
        select 
            rownum as ranking
            , name
        from
            (
            select embedding_model, embedding, name, doc
            from recipes g
            order by 
                vector_distance(
                    g.embedding
                    , vector_embedding(MXBAI_EMBED_LARGE_V1 using 'healthy dinner' as data)
                    , cosine)
            fetch first 3 rows only
            )
    ) loop
    
        dbms_output.put_line(r.ranking || ') ' || r.name);
    
    end loop;

end;
/


/* SCRIPT OUTPUT

create embeddings using mxbai-large llm
Created embeddings using MXBAI_EMBED_LARGE_V1 (1024 dimensions, FLOAT32) +000000000 00:00:24.578402000


PL/SQL procedure successfully completed.

Run Test Vector Search Using 'healthy dinner' showing top 3 results:
1) Curried Tofu
2) Shepherd's Pie
3) Miso Soup


PL/SQL procedure successfully completed.
*/