--4.0-dimension-wise-multiplication.sql
set heading off
prompt vector arithmetic is always dimension-wise

with base (operand, vec) as (
    values 
        ('x', to_vector('[125,24,115,42]'))
        ,('y', to_vector('[25,35,26,28]'))
), json_base as (
    select 
        operand
        , json(from_vector(vec)) as vector_as_json
    from base
), unnest_dimensions as (
    select b.operand, j.dimension#, j.dimension_value
    from 
        json_base b 
        nested vector_as_json[*] 
            columns(
                dimension# for ordinality
                , dimension_value number path '$'
                ) j
), pivot_details as (
    select operand, d1, d2, d3, d4
    from 
        unnest_dimensions
        pivot (
            max(dimension_value) for dimension# in
                (1 as d1, 2 as d2, 3 as d3, 4 as d4)
        )
), show_arithmetic_base as (
    select 
        json_array(x.d1,x.d2,x.d3,x.d4) as x_json
        , json_array(y.d1, y.d2, y.d3, y.d4) as y_json
        , json_array(
            'dimension 1 = ' || x.d1 || ' * ' || y.d1
            , 'dimension 2 = ' || x.d2 || ' * ' || y.d2
            , 'dimension 3 = ' || x.d3 || ' * ' || y.d3
            , 'dimension 4 = ' || x.d4 || ' * ' || y.d4
        ) as operation_json
        , json_array(
            x.d1 * y.d1
            , x.d2 * y.d2
            , x.d3 * y.d3
            , x.d4 * y.d4
        ) as result_json
    from pivot_details x cross join pivot_details y
    where x.operand = 'x' and y.operand = 'y'
), show_arithmetic as (
    select 
        to_vector(json_serialize(x_json)) as x_vector
        , to_vector(json_serialize(y_json)) as y_vector
        , translate(
            json_serialize(operation_json) 
            ,' ,[]"',' ' || chr(10)
        ) as operation_details
        , to_vector(json_serialize(result_json)) as result_vector
    from show_arithmetic_base
)
select 
    from_vector(x_vector) || vector_dimension_format(x_vector)
    || chr(10) || 'multiplied by ' 
    || chr(10) || from_vector(y_vector) || vector_dimension_format(y_vector)
    || chr(10) || chr(10) || operation_details
    || chr(10) || chr(10) || 'equals: ' || chr(10) 
    || from_vector(result_vector) || vector_dimension_format(result_vector) as operation_explanation
    --, x_vector * y_vector as verify_operation    
from show_arithmetic
/

/*
[1.25E+002,2.4E+001,1.15E+002,4.2E+001]FLOAT32
multiplied by 
[2.5E+001,3.5E+001,2.6E+001,2.8E+001]FLOAT32

dimension 1 = 125 * 25
dimension 2 = 24 * 35
dimension 3 = 115 * 26
dimension 4 = 42 * 28

equals: 
[3.125E+003,8.4E+002,2.99E+003,1.176E+003]FLOAT32
*/