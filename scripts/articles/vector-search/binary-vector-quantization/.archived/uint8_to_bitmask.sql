set serveroutput on;


---sql based solution for converting a byte in binary representation to integer
create or replace function bytestring_to_int8(p_bytestring in varchar2) return integer
is
    l_int integer;
begin

    select
    sum(power(2, 8 - o.bit_position) * to_number(substr(b.bytestring, o.bit_position,1))) as byte_as_int8
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
    cross apply (select level as bit_position connect by level <= length(b.bytestring)) o
    ]';

end bytestring_to_int8_m;
/
select 
     bin_to_num(b1h, b2h, b3h, b4h, b5l, b6l, b7l, b8l) as uint8  
from
(
    select p.bit_position, nvl(substr(s.byte, p.bit_position, 1),0) as bit
    from
        (select '10100111' as byte from dual) s
        cross apply (select level as bit_position connect by level <= 8) p
)
pivot (
    max(bit) for bit_position in (1 as b1h, 2 as b2h, 3 as b3h, 4 as b4h, 5 as b5l, 6 as b6l, 7 as b7l, 8 as b8l) 
)
/


---int8 to binary using recursive with
with calc (x, bit, exp2, bit_value) as (
    select 3, null, 8, null from dual
    union all
    select x - case when x - power(2, exp2 - 1) >= 0 then power(2, exp2 - 1) else 0 end
        , case when x - power(2,exp2-1) >= 0 then 1 else 0 end
        , exp2 - 1
        , case when x - power(2,exp2-1) >= 0 then 1 else 0 end * power(2, exp2 - 1)
    from calc where exp2 - 1 >= 0
)
--select c.bit, c.exp2, c.bit_value from calc
select listagg(c.bit) within group (order by exp2 desc) as byte, sum(c.bit_value) as uint8 from calc c
/

with calc(x, bit, exp2, bit_value) as (
    select 13, null, -1, null from dual
    union all
    select trunc(x/2), mod(trunc(x),2), exp2 + 1,  mod(trunc(x),2) * power(2, exp2 + 1)
    from calc 
    where exp2 < 7
)
--select c.bit, exp2, c.bit_value from calc c
select lpad(listagg(bit) within group(order by exp2 desc),8,'0') as byte, sum(bit_value) as uint8 
from calc
/

select lpad(listagg(bit) within group (order by lvl desc),8,'0') as byte
from
    (
    select level as lvl, sign(bitand(13, power(2, level - 1))) as bit
    from dual
    connect by power(2, level - 1) <= 13
    )
/


create or replace function uint8_to_bytestring(p_integer in integer) return varchar2
is
l_bytestring varchar2(8);
begin

with calc (x,bits,exp2) as (
select p_integer, to_char(null), 8 from dual
union all
select x - case when x - power(2,exp2 - 1) >= 0 then power(2,exp2-1) else 0 end
    , bits || case when x - power(2,exp2-1) >= 0 then '1' else '0' end
    , exp2 - 1
from calc where exp2 - 1 >= 0
)
select bits into l_bytestring
from calc where exp2 = 0;
return l_bytestring;

end uint8_to_bytestring;
/

create or replace function uint8_to_bytestring_m(p_integer in number) return varchar2
sql_macro(scalar)
is
l_bytestring varchar2(8);
begin

return q'[
    select 
        lpad(
            listagg(
                sign(
                    bitand(
                        p_integer, 
                        power(2, level - 1)
                        )
                    )
                ) within group (order by level desc)
            , 8, '0')
    from dual
    connect by power(2, level - 1) <= p_integer
]';

end uint8_to_bytestring_m;
/




--with base as (
--select level - 1 as uint8 from dual connect by level < 256
--)
select uint8
    , uint8_to_bytestring(uint8) as bytestring
    , (uint8_to_bytestring_m(uint8)) as bytestring_macro
    , (
        select lpad(listagg(sign(bitand(uint8, power(2,level-1)))) within group (order by level desc),8,'0') 
        from dual
        connect by power(2,level-1) <= uint8
    ) as bytestring_subquery
from (select level - 1 as uint8 from dual connect by level < 256) b
/

set serveroutput on;
begin
dbms_output.put_line(uint8_to_bytestring_m(42));
end;
/

select uint8_to_bytestring_m(42) as bytestring_macro from dual
/

declare
    my_uint8 number := 171;
    my_byte varchar2(8) := '10101011';
    
    function uint8_to_byte(p_uint8 in integer, p_debug in boolean default false)
    return varchar2
    is
        x number;
        l_bit number;
        l_byte varchar2(8);
    begin
        if p_uint8 >= power(2,8) then
            raise_application_error(-20101, 'Overflow: ' || p_uint8 || ' is greater than uuint8 max size of ' || (power(2,8) - 1));
        elsif p_uint8 < 0 then
            raise_application_error(-20102, 'Range Error: ' || p_uint8 || ' is outside the range of an unsigned 8 bit integer');
        end if;
        x := p_uint8;
        if p_debug then dbms_output.put_line('input ' || p_uint8 || ' uint8'); end if;
        for pwr in reverse 0..7 loop
            if power(2,pwr) > x then
                l_bit := 0;
            else 
                l_bit := 1;
                x := x - power(2,pwr);
            end if;
            if p_debug then dbms_output.put_line('    bit ' || (pwr + 1) || ' is ' || l_bit || ' = ' || l_bit || ' * 2 exp' || pwr || ' = ' || (l_bit * power(2,pwr))); end if;
            l_byte := l_byte || l_bit;        
        end loop;
        if p_debug then dbms_output.put_line('output ' || l_byte || ' binary'); end if;
        if p_debug then dbms_output.put_line(p_uint8 || ' uint8 = ' || l_byte || ' binary'); end if;
        return l_byte;
    end uint8_to_byte;

    function byte_to_uint8(p_byte in varchar2, p_debug in boolean default false) return integer
    is
        l_bit number;
        l_power2 number;
        l_bit_as_uint8 number;
        l_uint8 number := 0;
    begin
        if length(p_byte) > 8 then raise_application_error(-20101, p_byte || ' exceeds 8 characters, input limited to 8 binary values'); end if;
        if not regexp_like(p_byte,'^[01]{0,8}$') then raise_application_error(-20101, p_byte || ' is invalid, must be 0 or 1 for less than 8 characters'); end if;
        if p_debug then dbms_output.put_line('input byte = '|| p_byte); end if;
        for i in 1..8 loop
            l_bit := substr(p_byte, i, 1);
            l_power2 := 8 - i;
            l_bit_as_uint8 := l_bit * power(2,l_power2);
            l_uint8 := l_uint8 + l_bit_as_uint8;
            if p_debug then dbms_output.put_line('    bit ' || i || ' is ' || l_bit || ' = ' || l_bit || ' * 2 exp' || l_power2 || '=' || l_bit_as_uint8); end if;
        end loop;
        if p_debug then dbms_output.put_line('output uint8 = ' || l_uint8); end if;
        if p_debug then dbms_output.put_line(p_byte || ' binary = ' || l_uint8 || ' uint8'); end if;
        return l_uint8;
    end byte_to_uint8;

    function byte_to_raw_vector(p_byte in varchar2) return varchar2
    is
    l_vector varchar2(100);
    begin
        l_vector := rtrim(regexp_replace(p_byte,'(.){1}?','\1,'),',');
        l_vector := '[' || l_vector || ']';
        return l_vector;
    end byte_to_raw_vector;
begin
for i in 0..255 loop
    dbms_output.put_line(byte_to_raw_vector(uint8_to_byte(i)));
end loop;
--dbms_output.put_line('uint8 to byte expansion');
--for i in 0..255 loop
--my_uint8 := i;
--my_byte := uint8_to_byte(my_uint8);
--dbms_output.put_line(lpad(i,3,' ') || ' uint8 = ' || uint8_to_byte(my_uint8) || ' binary = ' || lpad(byte_to_uint8(my_byte),3,' ') || ' uint8');
--end loop;


--dbms_output.put_line(uint8_to_byte(42));

end;
/

with
    function uint8_to_byte(p_uint8 in integer) return varchar2
    is
        x number;
        l_bit number;
        l_byte varchar2(8);
    begin
        if p_uint8 >= power(2,8) then
            raise_application_error(-20101, 'Overflow: ' || p_uint8 || ' is greater than uuint8 max size of ' || (power(2,8) - 1));
        elsif p_uint8 < 0 then
            raise_application_error(-20102, 'Range Error: ' || p_uint8 || ' is outside the range of an unsigned 8 bit integer');
        end if;
        x := p_uint8;
        for pwr in reverse 0..7 loop
            if power(2,pwr) > x then
                l_bit := 0;
            else 
                l_bit := 1;
                x := x - power(2,pwr);
            end if;
            l_byte := l_byte || l_bit;        
        end loop;
        return l_byte;
    end uint8_to_byte;

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

function byte_to_raw_vector(p_byte in varchar2) return varchar2
is
l_vector varchar2(100);
begin
    l_vector := rtrim(regexp_replace(p_byte,'(.){1}?','\1,'),',');
    l_vector := '[' || l_vector || ']';
    return l_vector;
end byte_to_raw_vector;
function uint8_to_raw_vector(p_uint8 in integer) return varchar2
is
begin
    return byte_to_raw_vector(uint8_to_byte(p_uint8));
end uint8_to_raw_vector;

base as (
select level - 1 as n, uint8_to_byte(level - 1) as n_binary, uint8_to_raw_vector(level - 1) as n_raw_vector
connect by level < 256
)
select n, n_binary, n_raw_vector, to_vector(to_vector(n_raw_vector, 8, float32),*,binary) as my_vector, to_vector('['||n||']',8,binary)
from base
where n = 42
/

with base as (
select to_vector('[-123,123,0,1,-1,44,33,-65]',*,int8) as my_vector
)
select my_vector, to_vector(my_vector, *, binary) as my_binary_vector
from base
/


with base as (
select json('[11,-12,13e-3,14]') as jarray
), qbase as (
select 
    j.n, j.dim
    , case when j.n <= 0 then 0 else 1 end as q
from base b,
json_table(b.jarray,'$[*]' columns(dim for ordinality, n path '$.number()')) j
)
select json_arrayagg(n order by dim) as input_vector, json_arrayagg(q order by dim) as quantized_vector
from qbase
/

select v.v_id, v.v_vc, translate(v.v_vc,' []',' ') as v_vc_array
from 
(
values (1,'[1,-3,2,-4]'),(2, '[123,-23,32,-42]')
) v (v_id, v_vc) 
/


with base (v_id, v_vc,v_vc_array) as (
select v.v_id, v.v_vc, translate(v.v_vc,' []',' ') as v_vc_array
from 
(
values (1,'[1,-3,2,-4]'),(2, '[123,-23,32,-42]')
) v (v_id, v_vc) 
)
select b.v_id, i.idx as dim_n, regexp_substr(b.v_vc_array, '[^,]+',1, i.idx) as dim_val_n
from base b
join lateral (
select level as idx 
connect by level <= length(regexp_replace(b.v_vc_array,'[^,]+')) + 1
) i on 1 = 1
/



with base as (select level as n from dual connect by level <= 255)
select
    n,
    (select sum(level) from dual connect by level <=n) as subquery_expression,
    (with sqbase as (select level as x from dual connect by level <= 4) select listagg(x) from sqbase) as subquery_with
from base b
/

select level as bit connect by level <= 8
/

