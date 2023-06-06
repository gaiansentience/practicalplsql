set serveroutput on;
declare
    type t_item is record(version number, text varchar2(100));
    type t_list is table of t_item;-- index by pls_integer;
    type t_versions is table of t_list index by pls_integer;
    l_versions t_versions;
    l_all t_list := new t_list();
    
    cursor c_any(p_version in number) return t_item is 
        select 
            p_version as version
            , case p_version
                when 23 then 'upgraded too early' 
                when 21 then 'upgrade soon' 
                when 19 then 'upgrade soon' 
                else 'old release' 
            end as text 
        from dual;
    
$if dbms_db_version.version >= 23 $then
    cursor c_23 return t_item is
        with base (version, text) as
        ( 
            values 
            (23, 'developer preview'),
            (23, 'language enhancements')
        ) , base_plus as
        (
            select version, text from base
            union all select 23, 'unexpected syntax'
        )
        select version, text
        from base_plus;
$end

$if dbms_db_version.version >= 21 $then
    cursor c_21 return t_item is
        select 21 as version, 'innovation release' as text from dual
        union all select 21, 'new options' from dual;
$end

$if dbms_db_version.version >= 19 $then
    cursor c_19 return t_item is
        select 19 as version, 'production release' as text from dual
        union all select 19, 'upgrade soon' from dual;
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

for i in indices of l_versions loop
    l_all := l_all multiset union l_versions(i);
end loop;

for i in indices of l_all loop
    dbms_output.put_line(l_all(i).version || ' ' || l_all(i).text);
end loop;

--for i in indices of l_versions loop
--    for j in indices of l_versions(i) loop
--        dbms_output.put_line(l_versions(i)(j).version || ' ' || l_versions(i)(j).text);
--    end loop;
--end loop;

end;
/