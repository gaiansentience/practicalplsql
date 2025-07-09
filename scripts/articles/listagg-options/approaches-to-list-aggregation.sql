with 
function nt_to_clob(nt in sys.odcivarchar2list) return clob
is
ret clob;
is_first boolean := true;
begin
    for rec in (select column_value as val from table (nt)) loop
        if is_first then
            is_first := false;
            ret := rec.val;
        else
            ret := ret || ', ' || rec.val;
        end if;
    end loop;
    return ret;
end nt_to_clob;

base as (
select level as n, to_char(to_date(level,'yyyy'), 'year') n_text
from dual
connect by level < 10000
)
select 
    mod(n,6) as by_n
    , nt_to_clob(cast(collect(n_text order by n) as sys.odcivarchar2list)) as collect_1
    --, listagg(n, ', ') within group (order by n)
    --, listagg(n_text, ', ') within group (order by n) as listagg_1
    --, substr(xmlagg(xmlparse(content ', ' || n_text wellformed) order by n).getclobval(), 3) xml_1
    --, substr(xmlcast(xmlagg(xmlelement(V, ', ' || n_text) order by n).extract('//text()') as clob), 3) xml_2
    --, substr(dbms_xmlgen.convert(xmlagg(xmlelement(V, ', ' || n_text) order by n).extract('//text()').getclobval(), 3) xml_3
    , json_value(
        replace(json_arrayagg(n_text order by n returning clob),'","',', ')
        ,'$[0]' returning clob) json_1  --does not handle internal ","
    , json_value(
        json_transform(
            json{'myArray' value json_arrayagg(n_text order by n returning clob) returning clob},
            set '$.myArray' = path '$.myArray[*].listagg(", ")' 
            --set '$.copyMyArray' = path '$.myArray'
            returning clob)
        , '$.myArray' returning clob) as json_2  --listagg item method limited to 32k
    , json_value(
        json_transform(
            json{'myArray' value json_arrayagg(n_text order by n returning json) returning json},
            --set '$.myArray' = path '$.myArray[*].listagg(", ")' 
            set '$.copyMyArray' = path '$.myArray'
            returning json)
        , '$.myArray' returning clob) as json_3  --listagg item method limited to 32k        
from base
group by by_n
/


with base as (
select level as n, lpad(level,3900,level || 'padded') as val
from dual connect by level <= 5
), to_array as (
select json_object('myArray' value json_arrayagg(val returning clob) returning clob) as object_with_large_array
from base
)
select json_transform(object_with_large_array,
    set '$.copyArray' = path '$.myArray',
    set '$.myArray' = path '$.myArray[*].listagg(", ")'
    returning clob) as transformed
from to_array
/


--reproduce json_transform listagg 32k limit issue:   9 json elements in an array, 4k each... then listagg the array


--xmlagg and xmlType.transform

---still need data cartridge custom odci aggregate
