--1.01-vectors-are-not-equal.sql

Prompt Does Rome - Italy + France = Paris

with base as (
select 
    vector_embedding(ALL_MINILM_L6_V2 using 'Paris' as data) as paris
    , vector_embedding(ALL_MINILM_L6_V2 using 'France' as data) as France
    , vector_embedding(ALL_MINILM_L6_V2 using 'Rome' as data) as Rome
    , vector_embedding(ALL_MINILM_L6_V2 using 'Italy' as data) as Italy
), arithmetic_base as (
    select 
        rome - italy + france as equation
        , paris
    from base
)
select 
    case 
        when equation = paris then 'Rome - Italy + France = Paris' 
        else 'Rome - Italy + France <> Paris'
    end as check_equation
from arithmetic_base
/

--ORA-22848: cannot use VECTOR type as comparison key