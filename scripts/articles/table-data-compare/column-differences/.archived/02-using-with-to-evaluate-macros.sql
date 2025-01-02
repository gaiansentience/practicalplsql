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
from generate_rows(number_of_rows * number_of_rows, columns(##VALUE_ALIAS##))
where mod(##VALUE_ALIAS##,2) = 0
]';
l_sql := replace(l_sql, '##VALUE_ALIAS##', value_alias(1));
return l_sql;

end generate_even_rows;

select * from generate_even_rows(4, columns(even))
/


with
function split_strings_macro(delim_string in varchar2) return varchar2 sql_macro(table)
is
l_sql varchar2(4000);
begin

l_sql := q'~
select s
from
    (
    select regexp_substr(delim_string,'[^,]+',1, x.pos) as s
    from 
        (
        select level as pos from dual connect by level <= length(regexp_replace(delim_string,'[^,]')) + 1
        ) x
    )
where s is not null
~';

return l_sql;
end split_strings_macro;

 base (id,delim) as (
select 1, 'aa,bb,cc' from dual union all
select 2, 'xxx,yyyy,zzzz' from dual
)
select b.id, b.delim, s.*
from base b
cross apply (select * from split_strings_macro(b.delim)) s
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
function pad_byte(p_byte in varchar2) return varchar2 sql_macro(scalar)
is
begin
    return q'[
    lpad(p_byte, 8, '0')
    ]';
end pad_byte;

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
            pad_byte(p_byte)
            --lpad(p_byte, 8, '0') 
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

select greatest(null,3,2)
/
