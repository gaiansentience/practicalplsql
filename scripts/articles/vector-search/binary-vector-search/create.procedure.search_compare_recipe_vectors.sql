--create.procedure.search_compare_recipe_vectors.sql

prompt create a procedure to compare different model searches between float32 and binary

create or replace procedure search_compare_recipe_vectors(
    p_search_text in varchar2, 
    p_rows in number default 3, 
    p_metric in varchar2 default 'cosine', 
    p_use_binary in boolean default false
)
is
    l_model varchar2(100);
    l_format varchar2(100);
    l_dim_count number;
    l_vector_column varchar2(100);
    l_model_sql varchar2(1000);
    l_search_v vector;
    l_search_v_sql varchar2(4000);
    l_sql varchar2(4000);
    cv sys_refcursor;
    l_start timestamp;
    l_results sys.odcivarchar2list;
begin
    --get the model, format, dimensions currently loaded to recipe_vectors
    l_vector_column := 'embedding' || case when p_use_binary then '_binary' end;
    l_model_sql := '
    select 
        embedding_model
        , vector_dimension_format(##VECTOR_COLUMN##)
        , vector_dimension_count(##VECTOR_COLUMN##)
    from recipe_vectors 
    where rownum = 1';
    l_model_sql := replace(l_model_sql, '##VECTOR_COLUMN##', l_vector_column);
    execute immediate l_model_sql
    into l_model, l_format, l_dim_count;
    
    dbms_output.put_line(
        'Semantic search for [' || p_search_text || '] top k=' || p_rows);
    dbms_output.put_line(
        'Model ' || l_model || ', metric ' || p_metric); 
    dbms_output.put_line(
        'Use Column ' || l_vector_column 
        || ', dimensions ' || l_dim_count || ', format ' || l_format);
    
    --convert the search string to a vector using the correct model and format
    --wrap the call to vector_embeddings with the macro for a binary search
    if p_use_binary then
        l_search_v_sql := '
            select 
                to_binary_vector(
                    vector_embedding(##MODEL## using :search_text as data))
            ';
    else
        l_search_v_sql := '
            select 
                vector_embedding(##MODEL## using :search_text as data)
            ';        
    end if;
    l_search_v_sql := replace(l_search_v_sql, '##MODEL##', l_model);
    
    l_start := localtimestamp;
    execute immediate l_search_v_sql 
    into l_search_v using p_search_text;
    dbms_output.put_line('Time to get search vector: ' || to_char(localtimestamp - l_start));
    
    --build the semantic search query
    l_sql := '
        select name 
        from recipe_vectors
        order by vector_distance(##VECTOR_COLUMN##, :l_search_vector, ##METRIC##)
        fetch first :results rows only
        ';
    l_sql := replace(l_sql, '##METRIC##', p_metric);
    l_sql := replace(l_sql, '##VECTOR_COLUMN##', l_vector_column);
    
    l_start := localtimestamp;
    open cv for l_sql using l_search_v, p_rows;
    fetch cv bulk collect into l_results;
    close cv;
    dbms_output.put_line('Time to run search: ' || to_char(localtimestamp - l_start));
    for v in values of l_results loop
        dbms_output.put_line(v);
    end loop;
    
    dbms_output.put_line(lpad('-', 50, '-'));
    
end search_compare_recipe_vectors;
/
        
