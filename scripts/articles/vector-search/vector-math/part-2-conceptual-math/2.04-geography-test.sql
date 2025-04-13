--2.04-geography-test.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
--    v_country_capitol vector;
    l_distance number;
    l_city varchar2(100);
    l_distance_min number;
    l_capitol_city varchar2(100);
    v_cities    t_vectors;
    v_countries t_vectors;
    v_terms     t_vectors;
    
    cursor c_cities is
    with base(term) as (
    values 
        ('Paris'),('Rome'),('London'),('Oxford'),('Boston'),('Berlin'),('Munich')
        ,('Lima'),('Milan'),('Venice'),('Tokyo'),('Dublin'),('Chicago'),('Washington DC')
    )
    select b.term, vector_embedding(all_minilm_l6_v2 using b.term as data) as embedding
    from base b;  
    
    cursor c_countries is
    with base(term) as (
    values ('France'),('Italy'),('United Kingdom'),('Germany'),('Peru'),('Japan'),('United States')
    )
    select b.term, vector_embedding(all_minilm_l6_v2 using b.term as data) as embedding
    from base b; 
    
    cursor c_terms is
    with base(term) as (
    values ('capitol'),('city'),('country')
    )
    select b.term, vector_embedding(all_minilm_l6_v2 using b.term as data) as embedding
    from base b;     
begin   
    
    v_terms := t_vectors(for r in c_terms index r.term => r.embedding);
    v_countries := t_vectors(for r in c_countries index r.term => r.embedding);
    v_cities := t_vectors(for r in c_cities index r.term => r.embedding);
    
    for country_name, country_vector in pairs of v_countries loop
        
        for city_name, city_vector in pairs of v_cities loop
            l_distance := country_vector + v_terms('capitol') <=> city_vector;
            if l_distance_min is null then
                l_distance_min := l_distance;
                l_capitol_city := city_name;
            elsif l_distance < l_distance_min then
                l_distance_min := l_distance;
                l_capitol_city := city_name;
            end if;                
        end loop;
        
        dbms_output.put_line('(' || country_name || ' + capitol) is ' || l_capitol_city);
        
        --reset for the next country
        l_distance_min := null;
        l_capitol_city := null;
    end loop;
    
end;
/

/*
(France + capitol) is Paris
(Germany + capitol) is Berlin
(Italy + capitol) is Rome
(Japan + capitol) is Tokyo
(Peru + capitol) is Lima
(United Kingdom + capitol) is London
(United States + capitol) is Washington DC


PL/SQL procedure successfully completed.

*/