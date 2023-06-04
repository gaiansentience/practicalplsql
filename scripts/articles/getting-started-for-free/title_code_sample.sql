set serveroutput on;
declare
    type t_option is record(version number, text varchar2(100));
    type t_options is table of t_option index by pls_integer;
    l_options t_options;
begin

$if dbms_db_version.version >= 23 $then
    l_options := t_options(for r in (
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
        from base_plus
        ) sequence => r);    
$elsif dbms_db_version.version >= 21 $then
    l_options := t_options(for r in (
        select 21 as version, 'innovation release' as text from dual
        union all select 21, 'new options' from dual
        ) sequence => r);
$elsif dbms_db_version.version >= 19 $then
    select 19, 'production release'
    bulk collect into l_options
    from dual;
$else

    l_options(1) := t_option(
        dbms_db_version.version, 'older releases');
$end

$if dbms_db_version.version >= 21 $then
    for i in indices of l_options loop
$else
    for i in 1..l_options.count loop
$end
        dbms_output.put_line(l_options(i).version || ' ' || l_options(i).text);
    end loop;    

end;
/