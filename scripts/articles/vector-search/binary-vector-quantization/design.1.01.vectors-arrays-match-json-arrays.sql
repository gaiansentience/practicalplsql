--design.1.01.vectors-arrays-match-json-arrays.sql

column vector_array_text format a30
column json_array_text format a30

prompt a vector is the same shape as a json array
select 
    from_vector(
        to_vector(
            '[-22,-44,33,-13,26,-11,38,-7]'
            , 8, int8
            )
    ) as vector_array_text
/

select
    json_serialize(
        json[-22,-44,33,-13,26,-11,38,-7]
    ) as json_array_text
/

/*
a vector is the same shape as a json array

VECTOR_ARRAY_TEXT             
------------------------------
[-22,-44,33,-13,26,-11,38,-7]


JSON_ARRAY_TEXT               
------------------------------
[-22,-44,33,-13,26,-11,38,-7]
*/