--1.03-vector-similarity-plsql.sql

set serveroutput on;
declare
    vector_paris vector;
    vector_france vector;
    vector_rome vector;
    vector_italy vector;
    vector_london vector;
    vector_equation vector;
    vector_distance_1 number;
    vector_distance_2 number;
begin
    
    select 
        vector_embedding(ALL_MINILM_L6_V2 using 'Paris' as data) as paris
        , vector_embedding(ALL_MINILM_L6_V2 using 'France' as data) as France
        , vector_embedding(ALL_MINILM_L6_V2 using 'Rome' as data) as Rome
        , vector_embedding(ALL_MINILM_L6_V2 using 'Italy' as data) as Italy
        , vector_embedding(ALL_MINILM_L6_V2 using 'London' as data) as London
    into vector_paris, vector_france, vector_rome, vector_italy, vector_london;
        
    vector_equation := vector_rome - vector_italy + vector_france;
    
    vector_distance_1 := vector_distance(vector_equation, vector_paris);
    vector_distance_2 := vector_distance(vector_equation, vector_london);
    
    if vector_distance_1 < vector_distance_2 then
        dbms_output.put_line('(Rome - Italy + France) is more similar to Paris than London');
    else
        dbms_output.put_line('Not quite what we expected');
    end if;
    
end;
/

/*
(Rome - Italy + France) is more similar to Paris than London


PL/SQL procedure successfully completed.


*/