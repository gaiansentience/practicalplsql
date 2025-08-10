--design.1.12.test-with-recipe-vectors.sql

column id format 9
set long 4000 
set pagesize 0
column conversion_results format a80


prompt substitute the recipes table for the literal test vectors
prompt the result quantizes each 384 dimension float32 vector to binary dimension format
prompt vector values are wrapped in output from sqlplus
with base as (
    select
        r.name
        , r.embedding as vec
    from recipe_vectors r
), quantized_base as (
    select 
        b.name
        , case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
        , mod(jt.dim#, 8) as bit#
        , ceil(jt.dim#/8) as byte#
    from 
        base b,
        json_table (
            json(vector_serialize(b.vec returning clob))
            , '$[*]'
            columns(
                dim# for ordinality
                , dimval number path '$'
                )
            ) jt
), pivot_to_bytes as (
    select
        p.name
        , p.byte#
        , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
    from quantized_base q
    pivot(
        max(q.dim_bitval) for bit# in (
            1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
            , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        ) p
), converted_binary_vectors as (
    select 
        pb.name
        , to_vector(
            json_serialize(
                json_arrayagg(pb.uint_byte order by pb.byte#) 
                returning clob)
            , *, binary) as binary_vector
    from pivot_to_bytes pb
    group by pb.name
)
select
    'Recipe: ' || name || chr(10)
    || ' Converted Vector has ' || vector_dimension_count(binary_vector) || ' dimensions' || chr(10)
    || ' Converted Vector dimension format is ' || vector_dimension_format(binary_vector) || chr(10)
    || ' Serialized Vector: ' || chr(10)
    || vector_serialize(binary_vector) as conversion_results
from converted_binary_vectors
order by name
/

/*

substitute the recipes table for the literal test vectors
the result quantizes each 384 dimension float32 vector to binary dimension format
vector values are wrapped in output from sqlplus

Recipe: Banana Bread
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[247,99,154,232,136,98,211,26,221,217,105,140,30,79,89,186,96,148,112,187,23,187
,12,221,6,197,132,156,58,43,228,214,169,114,99,70,239,248,53,206,144,244,83,207,
180,243,16,152]

Recipe: Banana, Mango and Blueberry Smoothie
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[54,99,141,104,138,235,133,50,157,137,5,31,188,78,76,228,189,148,82,91,17,147,13
6,216,67,141,148,140,154,217,245,230,147,81,99,65,228,163,84,110,153,183,214,248
,156,1,94,30]

Recipe: Buckwheat Pancakes
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[31,18,129,70,152,189,195,52,150,83,117,188,158,95,249,246,48,236,49,6,57,171,29
,212,6,188,252,28,154,235,213,252,25,117,101,135,151,42,113,214,147,189,222,189,
28,1,29,46]

Recipe: Chocolate Cake
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[54,67,137,106,192,214,102,38,151,155,113,4,58,104,133,242,189,87,53,91,145,195,
76,120,88,137,212,76,152,237,244,116,153,61,167,119,85,232,44,218,154,53,230,39,
128,64,94,126]

Recipe: Curried Tofu
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[20,38,135,25,26,44,146,18,149,201,209,191,131,89,137,50,210,148,70,162,1,213,73
,145,14,129,180,168,152,201,214,118,185,117,170,199,228,235,233,202,146,245,210,
222,67,85,9,236]

Recipe: Granola
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[126,35,207,226,136,250,82,50,21,139,21,174,158,87,9,242,114,220,119,2,113,145,2
24,244,2,253,165,216,152,9,247,234,137,113,98,34,133,178,49,174,147,177,250,188,
1,1,12,167]

Recipe: Grilled Cheese Sandwiches
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[118,36,199,224,174,163,210,49,149,201,27,140,26,87,11,82,107,44,71,150,49,59,45
,252,74,241,132,200,176,9,245,240,179,56,123,35,140,129,61,206,146,215,92,254,36
,149,21,173]

Recipe: Miso Soup
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[114,134,192,17,26,109,131,3,149,217,193,31,152,152,139,144,248,196,67,139,149,2
23,232,240,64,66,244,234,156,249,227,100,53,82,67,215,212,5,89,90,130,231,148,15
8,80,22,94,239]

Recipe: Oatmeal Cookies
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[82,2,195,35,8,112,64,55,9,218,49,194,191,26,129,242,118,223,103,134,18,177,116,
232,54,157,213,236,28,9,245,240,153,53,97,19,205,186,21,188,178,125,199,253,12,1
69,12,46]

Recipe: Pumpkin Muffins
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[114,193,179,225,222,46,82,83,17,159,111,6,22,10,41,18,249,28,38,195,23,35,238,1
16,14,15,133,204,150,8,100,240,244,95,225,2,210,113,60,246,146,21,159,237,196,16
1,84,170]

Recipe: Raspberry Tarts
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[54,41,132,195,251,118,147,18,151,25,38,62,52,22,89,242,93,132,134,10,21,49,216,
204,90,203,199,200,154,45,229,224,57,21,99,71,228,168,20,206,218,195,215,79,184,
114,79,182]

Recipe: Shepherd's Pie
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[222,34,130,243,155,248,22,106,21,90,68,175,155,81,63,114,120,134,67,33,149,155,
63,194,71,146,212,216,152,201,237,146,57,87,103,71,244,234,135,222,147,219,142,1
90,242,0,127,247]

Recipe: Spaghetti Bowl
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[116,38,231,242,146,121,163,20,84,224,61,231,58,249,9,242,44,2,100,244,17,211,20
5,236,192,97,172,236,121,105,227,120,147,112,25,221,213,122,153,254,16,149,190,2
20,48,54,169,239]

Recipe: Spaghetti with Meatballs
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[118,38,231,242,146,125,139,84,20,192,45,239,58,249,8,244,52,2,116,100,17,211,13
7,236,198,97,164,232,25,73,161,104,146,112,11,249,213,94,153,254,16,149,190,216,
48,22,73,231]

Recipe: Strawberry Pie
 Converted Vector has 384 dimensions
 Converted Vector dimension format is BINARY
 Serialized Vector: 
[54,162,139,98,138,58,211,114,149,9,33,12,54,158,75,246,249,14,103,78,183,121,14
0,140,123,153,128,72,154,9,119,232,177,29,118,3,212,168,106,94,153,4,246,92,128,
26,87,158]


15 rows selected. 


*/
