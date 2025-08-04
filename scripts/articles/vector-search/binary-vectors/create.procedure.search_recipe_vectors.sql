--create.procedure.search_recipe_vectors.sql

create or replace procedure search_recipe_vectors(
    p_search in varchar2, 
    p_rows   in number default 3,
    p_model  in varchar2 default null,
    p_metric in varchar2 default 'cosine') 
is
    type t_row is record (ranking number, name recipes.name%type);
    type t_rows is table of t_row;
    l_rows t_rows;
    l_model varchar2(100);
    l_start timestamp := localtimestamp;
    l_sql varchar2(4000);
    cv sys_refcursor;
    c_dividing_line constant varchar2(80) := lpad('-', 80, '-');
begin
    --validate the vectors currently loaded
    select embedding_model 
    into l_model 
    from recipe_vectors
    fetch first row only;
    
    if p_model is not null and l_model <> p_model then
        raise_application_error(-20100, l_model || ' embeddings found, expecting ' || p_model);
    end if;
    
    l_sql := 
    'select 
        rownum as ranking, name
    from
        (
        select name
        from recipe_vectors g
        order by 
            vector_distance(
                g.embedding
                , vector_embedding(' || l_model || ' using :p_search as data)
                , ' || p_metric || ')
        fetch first :p_rows rows only
        )';
    
    dbms_output.put_line(c_dividing_line);
    dbms_output.put_line('Run Test Vector Search For [' || p_search || ']');
    
    open cv for l_sql 
    using p_search, p_rows;
    fetch cv bulk collect into l_rows;
    close cv;
    
    dbms_output.put_line('Search completed using ' || l_model);
    dbms_output.put_line('Vector Distance Metric ' || p_metric);
    dbms_output.put_line('Search duration: ' || to_char(localtimestamp - l_start));
    dbms_output.put_line('Search text = [' || p_search || ']');
    dbms_output.put_line('Top k=' || p_rows || ' results:');
    
    for v in values of l_rows loop
        dbms_output.put_line(v.ranking || ') ' || v.name);
    end loop;
    
    dbms_output.put_line(c_dividing_line);
    
end search_recipe_vectors;
/
