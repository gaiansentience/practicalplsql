
with 
    function row_generator_macro(
        p_rows in number
        , p_multiplier in number default 1
    )return varchar2 sql_macro(table)
    is
    begin
        return 
            '
            select level * p_multiplier as n 
            from dual 
            connect by level <= p_rows
            ';
    end row_generator_macro;
select n from row_generator_macro(6,5) n
/

with 
function generate_rows(number_of_rows in number, value_alias in dbms_tf.columns_t
) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin

l_sql := q'[
select level as ##VALUE_ALIAS##
from dual
connect by level <= number_of_rows
]';
l_sql := replace(l_sql, '##VALUE_ALIAS##', value_alias(1));
return l_sql;

end generate_rows;

function generate_even_rows(number_of_rows in number, value_alias in dbms_tf.columns_t
) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin
l_sql := q'[
select ##VALUE_ALIAS##
from generate_rows(number_of_rows * 2, columns(##VALUE_ALIAS##))
where mod(##VALUE_ALIAS##,2) = 0
]';
l_sql := replace(l_sql, '##VALUE_ALIAS##', value_alias(1));
return l_sql;

end generate_even_rows;

select * from generate_even_rows(4, columns(even))
/


with
function split_strings_macro(delim_string in varchar2, col_name in dbms_tf.columns_t) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin

l_sql := q'~
select ##split_value_alias##
from
    (
    select regexp_substr(delim_string,'[^,]+',1, x.pos) as ##split_value_alias##
    from 
        (
        select level as pos 
        from dual 
        connect by level <= length(regexp_replace(delim_string,'[^,]')) + 1
        ) x
    )
where ##split_value_alias## is not null
~';

l_sql := replace(l_sql, '##split_value_alias##', col_name(1));

return l_sql;
end split_strings_macro;

 base (id,delim) as (
select 1, 'aa,bb,cc' from dual union all
select 2, 'xxx,yyyy,zzzz' from dual union all
select 3, null from dual
)
select b.id, b.delim, s.*
from base b
outer apply (select * from split_strings_macro(b.delim, columns(val))) s
/


with
function split_many_strings_macro(data in dbms_tf.table_t, delim_column in dbms_tf.columns_t, value_column in dbms_tf.columns_t
) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin

l_sql := q'~
select b.*, s.##split_value_alias##
from
    data b
    outer apply 
    (
        select ##split_value_alias##
        from
            (
            select regexp_substr(b.##delimited_values##,'[^,]+',1, x.pos) as ##split_value_alias##
            from 
                (
                select level as pos 
                from dual 
                connect by level <= length(regexp_replace(b.##delimited_values##,'[^,]')) + 1
                ) x
            )
        where ##split_value_alias## is not null
    ) s
~';

l_sql := replace(l_sql, '##split_value_alias##', value_column(1));
l_sql := replace(l_sql, '##delimited_values##', delim_column(1));

return l_sql;
end split_many_strings_macro;

base (id, detail_list) as (
    select 1, 'aa,bb,cc,' from dual union all
    select 2, 'xxx,yyyy,,zzzz' from dual union all
    select 3, null from dual
)
select * from split_many_strings_macro(base, columns(detail_list), columns(detail_item)) s
/



with
function split_numbers(delim_string in varchar2) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin

l_sql := q'~
select n
from
    (
    select to_number(regexp_substr(delim_string,'[^,]+',1, x.pos)) as n
    from 
        (
        select level as pos from dual connect by level <= length(regexp_replace(delim_string,'[^,]')) + 1
        ) x
    )
where n is not null
~';

return l_sql;
end split_numbers;

select *
from split_numbers('1,2,7,,3')
/



select regexp_substr('1,2,3','[^,]+',1, x.pos) as n
from 
    (
    select level as pos from dual connect by level <= length(regexp_replace('1,2,3','[^,]')) + 1
    ) x
/


with 

function byte_to_number(p_byte in varchar2) return varchar2 sql_macro(scalar)
is
begin
    return q'[
    select
    bin_to_num(
        substr(source_byte, 1, 1)
        , substr(source_byte, 2, 1)
        , substr(source_byte, 3, 1)
        , substr(source_byte, 4, 1)
        , substr(source_byte, 5, 1)
        , substr(source_byte, 6, 1)
        , substr(source_byte, 7, 1)
        , substr(source_byte, 8, 1))
    from 
        (
        select
            --pad_byte(p_byte)
            lpad(p_byte, 8, '0') 
            as source_byte 
        from dual
        )
    ]';
end byte_to_number;


base (bin) as (
select '101010' from dual
union all
select '111' from dual
)
select 
    b.bin, byte_to_number(b.bin) as int8
--bin_to_num(substr(bin,1,1),substr(bin,2,1), substr(bin,3,1), substr(bin,4,1), substr(bin, 5,1), substr(bin, 6,1), substr(bin, 7,1), substr(bin, 8,1)) as int8
from base b
/



with 
function int8_to_binary(n in integer) return varchar2 sql_macro(scalar)
is
begin
    return
    '
    select listagg(sign(bitand(n, power(2, level -1)))) within group (order by level desc) as byte
    from dual connect by level <= 8
    ';
    
end int8_to_binary;
base as (select level as n from dual connect by level <= 255)
select n, int8_to_binary(n) as int8
from base
/

with 
function int8_to_binary(n in integer) return varchar2 
is
    pragma udf;
    b varchar2(8);
begin
    
    select listagg(sign(bitand(n, power(2, level -1)))) within group (order by level desc) as byte
    into b
    from dual connect by level <= 8;
    
    return b;
end int8_to_binary;
base as (select level as n from dual connect by level <= 255)
select n, int8_to_binary(n) as int8
from base
/


with 
function int8_to_binary(n in integer) return varchar2 sql_macro(table)
is
begin
    return
    '
    select listagg(sign(bitand(n, power(2, level -1)))) within group (order by level desc) as byte
    from dual connect by level <= 8
    ';
    
end int8_to_binary;
base as (select level as n from dual connect by level <= 255)
select b.n, (select byte from int8_to_binary(b.n)) as int8
from base b
/

select listagg(sign(bitand(42, power(2, level -1)))) within group (order by level desc) as byte
from dual connect by level <= 8
/

select 42 as n, level - 1 as pwr, sign(bitand(42, power(2, level -1))) as bit
from dual connect by level <= 8
/


with base as (select level as n from dual connect by level <= 255)
select 
    n
    , (
     select listagg(sign(bitand(n, power(2, level -1)))) within group (order by level desc)
     from dual connect by level <= 8
     ) as byte
from base
/