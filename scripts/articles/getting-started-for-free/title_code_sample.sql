set serveroutput on;
declare
    type t_option is record(version number, text varchar2(100));
    type t_options is table of t_option index by pls_integer;
    l_options t_options;
begin

    l_options := t_options(
        t_option(23, 'container image'),
        t_option(23, 'virtual box appliance'),
        t_option(23, 'full installation'),
        t_option(21, 'oracle express'),
        t_option(21, 'oci autonomous database'),
        t_option(21, 'full installation'),
        t_option(19, 'live sql'),
        t_option(19, 'virtual box appliance'),
        t_option(19, 'oci autonomous database'),
        t_option(19, 'full installation'),
        t_option(12, 'virtual box appliance')
        );
        
    dbms_output.put_line('There are many options for setting up a development environment');
    
$if dbms_db_version.version >= 21 $then
    for i in indices of l_options loop
$else
    for i in 1..l_options.count loop
$end
        dbms_output.put_line(l_options(i).version || ' ' || l_options(i).text);
    end loop;    

end;
/