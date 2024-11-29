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
function split_strings(delim_string in varchar2) return varchar2 sql_macro(table)
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
end split_strings;

select *
from split_strings('abc,def,xyz,,3')
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



