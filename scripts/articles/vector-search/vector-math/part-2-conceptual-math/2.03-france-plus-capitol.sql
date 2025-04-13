--2.03-france-plus-capitol.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    v_cities    t_vectors;
    l_distance number;
    l_distance_min number;
    l_capitol_city varchar2(100);
    d number;
    i varchar2(100);
    d_keep number;
    i_keep varchar2(100);
    

    cursor c_cities is
    with base(term) as (
    values 
        ('Paris'),('Rome'),('London'),('Oxford'),('Boston'),('Berlin'),('Munich')
        ,('Lima'),('Milan'),('Venice'),('Tokyo'),('Dublin'),('Chicago'),('Washington DC')
    )
    select b.term, vector_embedding(all_minilm_l6_v2 using b.term as data) as embedding
    from base b;  
    
begin   

    select vector_embedding(all_minilm_l6_v2 using 'France' as data) into v('France');
    select vector_embedding(all_minilm_l6_v2 using 'capitol' as data) into v('capitol');
    
    v_cities := t_vectors(for r in c_cities index r.term => r.embedding);
    
    for city_name, city_vector in pairs of v_cities loop
        dbms_output.put_line('Checking similarity for ' || city_name);
        l_distance := vector_distance(v('France') + v('capitol'), city_vector); 
        
        if l_distance_min is null then 
            l_distance_min := l_distance;
            l_capitol_city := city_name;  
        elsif l_distance < l_distance_min then
            l_distance_min := l_distance;
            l_capitol_city := city_name;
        end if;
    end loop;
    
    dbms_output.put_line('(France + capitol) is most similar to ' || l_capitol_city);
    
end;
/

/*
Checking similarity for Berlin
Checking similarity for Boston
Checking similarity for Chicago
Checking similarity for Dublin
Checking similarity for Lima
Checking similarity for London
Checking similarity for Milan
Checking similarity for Munich
Checking similarity for Oxford
Checking similarity for Paris
Checking similarity for Rome
Checking similarity for Tokyo
Checking similarity for Venice
Checking similarity for Washington DC
(France + capitol) is most similar to Paris


PL/SQL procedure successfully completed.


*/