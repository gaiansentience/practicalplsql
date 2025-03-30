


with base(term) as (
values ('Paris'), ('France'), ('Capitol'), ('Rome'), ('Italy')
), vectors as (
select b.term, vector_embedding(ALL_MINILM_L6_V2 using b.term as data) as vec
from base b
)
select
--(select vec from vectors where term = 'Paris') as paris
--from dual
    (select vec from vectors where term = 'Paris') as Paris
    ,(select vec from vectors where term = 'France') as France
--    ,(select vec from vectors where term = 'Rome') as Rome
--    ,(select vec from vectors where term = 'Italy') as Italy
from dual
/

--Rome - Italy + France = Paris

with base as (
select 
    vector_embedding(ALL_MINILM_L6_V2 using 'Paris' as data) as paris
    ,vector_embedding(ALL_MINILM_L6_V2 using 'France' as data) as France
    ,vector_embedding(ALL_MINILM_L6_V2 using 'Rome' as data) as Rome
    ,vector_embedding(ALL_MINILM_L6_V2 using 'Italy' as data) as Italy
    ,vector_embedding(ALL_MINILM_L6_V2 using 'capitol' as data) as capitol
)
--select rome - italy + france as analogy, paris from base
select rome - italy, paris - france, italy + capitol, rome, france + capitol, paris
from base
/

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v_paris vector;
    v_france vector;
    v_rome vector;
    v_italy vector;
    v_london vector;
    v_england vector;
    v_capitol vector;
    v_temp vector;
    v t_vectors;
    cursor c_vectors is
    with base(term) as (
    values ('Paris'),('France'), ('Rome'),('Italy'),('London'),('England'),('capitol'),('city'),('country'),('Oxford'),('Boston')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;    
begin
    
    
    select 
    vector_embedding(ALL_MINILM_L6_V2 using 'Paris' as data) as paris
    ,vector_embedding(ALL_MINILM_L6_V2 using 'France' as data) as France
    ,vector_embedding(ALL_MINILM_L6_V2 using 'Rome' as data) as Rome
    ,vector_embedding(ALL_MINILM_L6_V2 using 'Italy' as data) as Italy
    ,vector_embedding(ALL_MINILM_L6_V2 using 'London' as data) as London
    ,vector_embedding(ALL_MINILM_L6_V2 using 'England' as data) as England    
    ,vector_embedding(ALL_MINILM_L6_V2 using 'capitol' as data) as capitol
    into v_paris, v_france, v_rome, v_italy, v_london, v_england, v_capitol;
    
    v_temp := v_rome - v_italy + v_france;
    dbms_output.put_line( vector_distance(v_temp, v_paris));
    
    v_temp := v_paris - v_france + v_italy;
    dbms_output.put_line( vector_distance(v_temp, v_rome));    
    
    v_temp := v_london - v_england + v_italy;
    dbms_output.put_line( vector_distance(v_temp, v_rome));      
    
    v_temp := v_france + v_paris;
    dbms_output.put_line( vector_distance(v_temp, v_capitol));
    
    v_temp := v_italy + v_rome;
    dbms_output.put_line( vector_distance(v_temp, v_capitol));
    
    v_temp := v_england + v_london;
    dbms_output.put_line( vector_distance(v_temp, v_capitol));

    v_temp := v_england + v_capitol;
    dbms_output.put('(england + capitol) <=> london');
    dbms_output.put_line( vector_distance(v_temp, v_london));     
    
    dbms_output.put('(england + capitol) <=> rome');
    dbms_output.put_line( vector_distance(v_temp, v_rome));  
    
    dbms_output.put('(england + capitol) <=> paris');
    dbms_output.put_line( vector_distance(v_temp, v_paris));   

    
    v_temp := v_italy + v_capitol;
    dbms_output.put('(italy + capitol) <=> london');
    dbms_output.put_line( vector_distance(v_temp, v_london));     
    
    dbms_output.put('(italy + capitol) <=> rome');
    dbms_output.put_line( vector_distance(v_temp, v_rome));  
    
    dbms_output.put('(italy + capitol) <=> paris');
    dbms_output.put_line( vector_distance(v_temp, v_paris));   
    
   
    v_temp := v_france + v_capitol;
    dbms_output.put('(france + capitol) <=> london');
    dbms_output.put_line( vector_distance(v_temp, v_london));     
    
    dbms_output.put('(france + capitol) <=> rome');
    dbms_output.put_line( vector_distance(v_temp, v_rome));  
    
    dbms_output.put('(france + capitol) <=> paris');
    dbms_output.put_line( vector_distance(v_temp, v_paris));       


    --open c_vectors;
    v := t_vectors(for r in c_vectors index r.term => r.embedding);
    
    v_temp := v('France') + v('capitol');
    dbms_output.put('(france + capitol) <=> paris');
    dbms_output.put_line( vector_distance(v_temp, v('Paris')));   


    
end;
/


set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);

    v_temp vector;
    v t_vectors;
    d number;
    i varchar2(100);
    
    cursor c_vectors is
    with base(term) as (
    values ('Paris'),('France'), ('Rome'),('Italy'),('London'),('England'),('capitol'),('city'),('country'),('Oxford'),('Boston')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;    
begin   


    --open c_vectors;
    v := t_vectors(for r in c_vectors index r.term => r.embedding);
    
    v_temp := v('France') + v('capitol');


    dbms_output.put('(france + capitol) <=> rome');
    dbms_output.put_line( vector_distance(v_temp, v('Rome')));  
    
    dbms_output.put('(france + capitol) <=> boston');
    dbms_output.put_line( vector_distance(v_temp, v('Boston')));   
    
    dbms_output.put('(france + capitol) <=> paris');
    dbms_output.put_line( vector_distance(v_temp, v('Paris')));   
    
    
    
    for idx,val in pairs of v loop
        if d is null then d := vector_distance(v_temp, val); i := idx;  
        elsif idx not in ( 'France', 'capitol') then
            if vector_distance(v_temp, val) < d then d := vector_distance(v_temp, val); i := idx; end if;
        end if;
    end loop;
    
    dbms_output.put_line('(france + capitol) is closest to ' || i);
    
end;
/


set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);

    v_temp vector;
    v t_vectors;
    d number;
    i varchar2(100);
    v_cities t_vectors;
    v_countries t_vectors;
    v_terms t_vectors;
    
    cursor c_cities is
    with base(term) as (
    values ('Paris'),('Rome'),('London'),('Oxford'),('Boston'),('Berlin'),('Lima'),('Milan'), ('Venice'),('Tokyo'),('Dublin')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base order by term;  
    
    cursor c_countries is
    with base(term) as (
    values ('France'),('Italy'),('UK'),('Germany'),('Peru'),('Japan')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;  
    
    cursor c_terms is
    with base(term) as (
    values ('capitol'),('city'),('country')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;      
begin   


    
    v_terms := t_vectors(for r in c_terms index r.term => r.embedding);
    v_countries := t_vectors(for r in c_countries index r.term => r.embedding);
    v_cities := t_vectors(for r in c_cities index r.term => r.embedding);
    
    v_temp := v_countries('France') + v_terms('capitol');  
    for city,city_v in pairs of v_cities loop
        if d is null then d := vector_distance(v_temp, city_v); i := city;  
        else
            if vector_distance(v_temp, city_v) < d then d := vector_distance(v_temp, city_v); i := city; end if;
        end if;
    end loop;
    
    dbms_output.put_line('(France + capitol) = ' || i);
    
    
    for country, country_v in pairs of v_countries loop
        v_temp := country_v + v_terms('capitol');
        
        for city,city_v in pairs of v_cities loop
            if d is null then d := vector_distance(v_temp, city_v); i := city;  
            else
                if vector_distance(v_temp, city_v) < d then d := vector_distance(v_temp, city_v); i := city; end if;
            end if;
        end loop;
        
        dbms_output.put_line('('||country||' + capitol) = ' || i);
        d := null;
        i := null;
    end loop;
    
end;
/