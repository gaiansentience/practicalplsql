--1.02-vectors-use-similarity.sql

Prompt Is (Rome - Italy + France) more similar to Paris or London?

with base as (
select 
    vector_embedding(ALL_MINILM_L6_V2 using 'Paris' as data) as paris
    , vector_embedding(ALL_MINILM_L6_V2 using 'France' as data) as France
    , vector_embedding(ALL_MINILM_L6_V2 using 'London' as data) as London
    , vector_embedding(ALL_MINILM_L6_V2 using 'Rome' as data) as Rome
    , vector_embedding(ALL_MINILM_L6_V2 using 'Italy' as data) as Italy
), arithmetic_base as (
select rome - italy + france as equation, paris, rome, london
from base
)
select 
    case 
        when vector_distance(equation, paris) < vector_distance(equation, london) then
            'Rome - Italy + France is more similar to Paris than London'
        else 'Rome - Italy + France is not more similar to Paris than London'
    end as check_equation
from arithmetic_base
/

/*
Is (Rome - Italy + France) more similar to Paris or London?

CHECK_EQUATION                                                
--------------------------------------------------------------
Rome - Italy + France is more similar to Paris than London
*/