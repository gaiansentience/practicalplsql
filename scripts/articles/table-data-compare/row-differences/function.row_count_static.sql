create or replace function row_count_static
return varchar2
$if dbms_db_version.version = 19 $then 
sql_macro
$elsif dbms_db_version.version >= 21 $then 
sql_macro(table)
$end
is
begin
    return 'select count(*) as row_count from products_source';
end row_count_static;
/


select * from row_count_static()
/

