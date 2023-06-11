set feedback off;
set pagesize 0;

--23
with v23_base (version, text,included) as
( 
    values 
    (23, 'free developer preview release',true),
    (23, 'multiple values clause',true),
    (23, 'sql boolean datatype',to_boolean(1)),
    (23, 'sql domains', true),
    (23, 'plsql simple case enhancements', true),
    (23, 'json relational duality views', true),
    (23, 'plsql returning old values', true)
) , base_plus as
(
    select version, text from v23_base where included
    union all 
    select 23, 'optional from clause'
)
select version, text from base_plus;

--21
with v21_base as
(
    select 
        21 as version,
        case level 
            when 1 then 'json constructor'
            when 2 then 'cursor iteration controls'
            when 3 then 'analytic window enhancements'
            when 4 then 'non persistable schema objects'
            when 5 then 'sql macros'
            when 6 then 'innovation release'
        end as text
    from dual connect by level <= 6
), v21_json_base as
(
    select json{
            'version' : (d.version), 
            'text' : (d.text)
        } as jdoc
    from v21_base d
), json_relational as
(
    select j.version, j.text
    from
        v21_json_base d,
        json_table (d.jdoc
            columns (
                version number path '$.version.number()', 
                text varchar2(50) path '$.text.string()'
            )
    ) j
)
select version, text from json_relational;

--19
with v19_base as
(
    select 
        19 as version, 
        case level 
            when 1 then 'json_object simplifications'
            when 2 then 'json path syntax relaxation' 
            when 3 then 'listagg distinct' 
            when 4 then 'polymorphic table functions'
            when 5 then 'time for upgrade'
        end as text 
    from dual connect by level <= 5
), json_base as
(
    select json_object(d.*) as jdoc
    from v19_base d
), json_relational as
(
    select j.version, j.text
    from
        json_base d,
        json_table (d.jdoc
            columns (
                VERSION number,
                text varchar2(30) path '$.TEXT.string()'
            )
    ) j
)
select version, text from json_relational;

--12
with v12_base as
(
    select 
        12 as version,
        case level
            when 1 then 'sql xml functions'
            when 2 then 'xmltype constructor'
            when 3 then 'with clause functions'
            when 4 then 'plsql optimizer'
            when 5 then 'plsql conditional compilation'
            when 6 then 'sql case'
            when 6 then 'past due for upgrade'
        end as text from dual connect by level <= 6
    union all 
    select 12, 'xmltype' from dual
), xml_base as
(
    select 
        xmlelement(
            "xml_features", 
            xmlagg(
                xmlelement(
                    "feature", 
                    xmlforest(
                        d.version as "version", 
                        d.text as "text")
                )
            )
        ) as xdoc
    from v12_base d
), xml_relational as
(
select x.version, x.text
from 
    xml_base b,
    xmltable('/xml_features/feature' passing b.xdoc
        columns 
            version number path 'version', 
            text varchar2(30) path 'text'
    ) x
)
select version, text from xml_relational;

--8
select
    8 as version,
    decode(level,
        1, 'analytic functions',
        2, 'materialized views',
        3, 'partitioned tables',
        4, 'decode',
        4, 'plsql language',
        5, 'pipelined functions',
        6, 'cursor for loop',
        7, 'bulk collect and forall',
        8, 'plsql packages',
        9, 'autonomous transactions',
        10, 'connect by queries') as text
from dual connect by level <= 10;