set serveroutput on;
declare
    type t_item is record(version number, text varchar2(100));
    type t_list is table of t_item index by pls_integer;
    type t_versions is table of t_list index by pls_integer;
    l_versions t_versions;
    l_all t_list := t_list();
    i number;
    cursor c_8 return t_item is 
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

$if dbms_db_version.version >= 23 $then

    cursor c_23 return t_item is
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

$end

$if dbms_db_version.version >= 21 $then

    cursor c_21 return t_item is
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
        
$end

$if dbms_db_version.version >= 19 $then

    cursor c_19 return t_item is
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
        
$end

$if dbms_db_version.version >= 12 $then

    cursor c_12 return t_item is
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
    
$end

begin

$if dbms_db_version.version >= 23 $then
    l_versions(23) := t_list(for r in c_23 sequence => r);
$end

$if dbms_db_version.version >= 21 $then
    l_versions(21) := t_list(for r in c_21 sequence => r);
$end

$if dbms_db_version.version >= 19 $then
    open c_19;
    fetch c_19 bulk collect into l_versions(19);
    close c_19;
$end 

$if dbms_db_version.version >= 12 $then
    open c_12;
    fetch c_12 bulk collect into l_versions(12);
    close c_12;
$end 

    open c_8;
    fetch c_8 bulk collect into l_versions(8);
    close c_8;

$if dbms_db_version.version >= 21 $then
    for i in indices of l_versions loop
$else
    i := l_versions.first;
    while i is not null loop
$end
        l_all := l_all multiset union l_versions(i);
$if dbms_db_version.version < 21 $then
        i := l_versions.next(i);
$end
    end loop;

$if dbms_db_version.version >= 21 $then
    for i in indices of l_all loop
$else
    for i in 1..l_all.count loop
$end
        dbms_output.put_line(l_all(i).version || ' ' || l_all(i).text);
    end loop;    

exception 
    when others then
        dbms_output.put_line(sqlerrm);
end;
/