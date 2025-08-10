select * from user_tables where table_name not like '%$%';

select id, name,embedding, length(from_vector(embedding returning clob)) as vector_length,vector_dimension_count(embedding) as dim_count, vector_dimension_format(embedding) as dim_fmt
from recipes
/

with base as (
select json{r.*} as jrow
from recipes r
)
select json_serialize(jrow returning clob pretty) as jdoc
from base
/


with 
function byte_to_uint8(p_byte in varchar2) return integer 
    is
        l_bit number;
        l_power2 number;
        l_bit_as_uint8 number;
        l_uint8 number := 0;
    begin
        if length(p_byte) > 8 then raise_application_error(-20101, p_byte || ' exceeds 8 characters, input limited to 8 binary values'); end if;
        if not regexp_like(p_byte,'^[01]{0,8}$') then raise_application_error(-20101, p_byte || ' is invalid, must be 0 or 1 for less than 8 characters'); end if;
        for i in 1..8 loop
            l_bit := substr(p_byte, i, 1);
            l_power2 := 8 - i;
            l_bit_as_uint8 := l_bit * power(2,l_power2);
            l_uint8 := l_uint8 + l_bit_as_uint8;
        end loop;
        return l_uint8;
    end byte_to_uint8;
base as (
select id, json(embedding) as jvector
from recipes r
where r.id = 5
), qbase as (
select b.id, j.dim, j.dim_val, case when j.dim_val <= 0 then 0 else 1 end as q_dim_val
from base b,
json_table(b.jvector, '$[*]' columns (dim for ordinality, dim_val binary_float path '$')) j
where j.dim <= 8
), base2 as (
select b.id, json_arrayagg(b.dim_val order by b.dim) as v8, json_arrayagg(b.q_dim_val order by b.dim returning clob) as quantized_byte_array, listagg(b.q_dim_val) within group (order by b.dim) as quantized_byte
from qbase b
group by b.id
)
select id, quantized_byte, bytestring_to_int8_m(quantized_byte) as byte_as_uint8,quantized_byte_array, to_vector(quantized_byte_array) as v8q_float32, to_vector(v8) as v8_float32
from base2
/

select id, embedding, vector_dimension_count(embedding) as dim_ct, vector_dimension_format(embedding) as dim_fmt, to_vector(embedding, *, binary) as to_binary_vector
from recipes r
/

select * from recipes
/

select byte_to_uint8('10101010') from dual
/

---sql based solution for converting a byte in binary representation to integer
create or replace function bytestring_to_int8(p_bytestring in varchar2) return integer
is
    l_int integer;
begin

    select
    sum(power(2, 8 - o.bit_position) * to_number(substr(b.bytestring,o.bit_position,1))) as byte_as_int8
    into l_int
    from (select lpad(p_bytestring,8,'0') as bytestring from dual) b
    cross apply(select level as bit_position connect by level <= length(b.bytestring)) o;
    return l_int;
end bytestring_to_int8;
/

--scalar macro to convert byte in binary representation to integer
create or replace function bytestring_to_int8_m(p_bytestring in varchar2
) return varchar2
sql_macro (scalar)
is
begin

return q'[
    select
    sum(power(2, 8 - o.bit_position) * to_number(substr(b.bytestring,o.bit_position,1))) as byte_as_int8
    from (select lpad(p_bytestring,8,'0') as bytestring from dual) b
    cross apply(select level as bit_position connect by level <= length(b.bytestring)) o
    ]';

end bytestring_to_int8_m;
/

with base (id, bit_string) as (
values ('a','1011'),('b','10101100'),('c','0101010'),('d','10101010'),('e','1')
)
select id, bit_string, bytestring_to_int8_m(bit_string) as int8
from base
/

--150 = [1,0,0,1,0,1,1,0]
select bin_to_num(1,0,0,1,0,1,1,0)
/

with base (id, bit_string) as (
values ('a','1011'),('b','10101100'),('c','0101010'),('d','10101010'),('e','1')
)
select id, listagg(bit_value) within group (order by bit_position) as byte_value, sum(bit_as_integer) as byte_as_int8
from
(
select
    b.id
    , o.bit_position
    , substr(b.bit_string, o.bit_position,1) as bit_value
    , power(2, 8 - o.bit_position) * to_number(substr(b.bit_string, o.bit_position,1)) as bit_as_integer
from (select id, lpad(bit_string,8,'0') as bit_string from base) b
cross apply(select level as bit_position connect by level <= 8) o
order by id, bit_position
)
group by id
/

with base (id, bit_string) as (
values ('a','1011'),('b','10101100'),('c','0101010'),('d','10101010'),('e','1')
)
select
    i.id
    , listagg(i.bit_value) within group (order by i.bit_position) as byte_value
    , sum(i.bit_integer_value) as byte_integer_value
from 
(
select
    id
    , o.bit_position
    , substr(b.padded_bits, o.bit_position, 1) as bit_value
    , power(2, b.bit_count - o.bit_position) * to_number(substr(b.padded_bits, o.bit_position, 1)) as bit_integer_value 
from 
    (
    select 
        id
        , lpad(bit_string, ceil(length(bit_string)/8) * 8, '0') as padded_bits
        , ceil(length(bit_string)/8) * 8 as bit_count
    from base --where id = 'd'
    ) b
    cross apply(select level as bit_position connect by level <= b.bit_count) o
) i
group by i.id
/

with base (bit_string) as (
values ('1011'),('10101100'),('0101010'),('10101010'),('1')
)
select b.bit_string, length(b.bit_string) , lpad(b.bit_string, ceil(length(b.bit_string)/8) * 8, '0') as all_bits, ceil(length(b.bit_string)/8) * 8 as bit_count, ceil(length(b.bit_string)/8) as byte_position
from base b
/

create or replace function byte_to_uint8(p_byte in varchar2) return integer 
is
    l_bit number;
    l_power2 number;
    l_bit_as_uint8 number;
    l_uint8 number := 0;
begin
    if length(p_byte) > 8 then raise_application_error(-20101, p_byte || ' exceeds 8 bits, input limited to 8 binary quanta'); end if;
    if not regexp_like(p_byte,'^[01]{0,8}$') then raise_application_error(-20101, p_byte || ' is invalid, must be 0 or 1'); end if;
    for i in 1..8 loop
        l_bit := substr(p_byte, i, 1);
        l_power2 := 8 - i;
        l_bit_as_uint8 := l_bit * power(2,l_power2);
        l_uint8 := l_uint8 + l_bit_as_uint8;
    end loop;
    return l_uint8;
end byte_to_uint8;
/


select json_arrayagg(binary_vector_dimension order by byte_order returning clob) as raw_binary_vector
from
(
    select byte_order
       -- , byte_to_uint8(quantized_byte) as binary_vector_dimension
        , bytestring_to_int8_m(quantized_byte) as binary_vector_dimension
    from
    (
        select byte_order, listagg(quantized_bit) within group (order by dimension_number) as quantized_byte
        from 
        (
            select
                j.dimension_number, ceil(j.dimension_number/8) as byte_order, j.dimension_value, case sign(j.dimension_value) when 1 then 1 else 0 end as quantized_bit
            from
                (select '[1.11,-2.22,3.33,-4.44,5.55,6.66,7.77,8.88,9.99,10.10,-11.11,12.12,-13.13,14.14,-15.15,16.16]' as serial_vector) b,
                json_table(b.serial_vector, '$[*]' columns(dimension_number for ordinality, dimension_value path '$.number()')) j
        )
        group by byte_order
    )
)
/

create or replace function to_binary_vector(p_vector in clob) return clob 
is
v clob;
begin

select json_arrayagg(binary_vector_dimension order by byte_order returning clob) as raw_binary_vector
into v
from
(
    select byte_order, byte_to_uint8(quantized_byte) as binary_vector_dimension
    from
    (
        select byte_order, listagg(quantized_bit) within group (order by dimension_number) as quantized_byte
        from 
        (
            select
                j.dimension_number, ceil(j.dimension_number/8) as byte_order, j.dimension_value, case sign(j.dimension_value) when 1 then 1 else 0 end as quantized_bit
            from
                (select p_vector as serial_vector) b,
                json_table(b.serial_vector, '$[*]' columns(dimension_number for ordinality, dimension_value path '$.number()')) j
        )
        group by byte_order
    )
);

return v;

end to_binary_vector;
/

create or replace function to_binary_vector_m(p_vector in clob) return varchar2 
sql_macro(scalar)
is
v clob;
begin

return q'!
select json_arrayagg(binary_vector_dimension order by byte_order returning clob) --as raw_binary_vector
from
(
    select byte_order, bytestring_to_int8_m(quantized_byte) as binary_vector_dimension
    from
    (
        select byte_order, listagg(quantized_bit) within group (order by dimension_number) as quantized_byte
        from 
        (
            select
                j.dimension_number, ceil(j.dimension_number/8) as byte_order, j.dimension_value, case sign(j.dimension_value) when 1 then 1 else 0 end as quantized_bit
            from
                (select p_vector as serial_vector) b,
                json_table(b.serial_vector, '$[*]' columns(dimension_number for ordinality, dimension_value path '$.number()')) j
        )
        group by byte_order
    )
)
!';

--return v;

end to_binary_vector_m;
/

select id, name, v, vector_dimension_count(v) as v_dim_count, vector_dimension_format(v) as v_dim_fmt, to_vector(v,*,binary) as direct_to_binary_v, bv, vector_dimension_count(bv) as bv_dim_count, vector_dimension_format(bv) as bv_dim_fmt
from
(
select id, name, v, to_vector(to_binary_vector_m(from_vector(v returning clob)),*,binary) as bv
from genvec
);
