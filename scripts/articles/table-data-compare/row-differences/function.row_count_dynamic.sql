create or replace function row_count_dynamic(
    p_table in dbms_tf.table_t)
return varchar2
$if dbms_db_version.version = 19 $then 
sql_macro
$elsif dbms_db_version.version >= 21 $then 
sql_macro(table)
$end
is
begin
    return 'select count(*) as row_count from p_table';
end row_count_dynamic;
/


select * from row_count_dynamic(products_target)
/

select * from row_count_dynamic(user_objects)
/

with base as (
    select * from products_source
    union all
    select * from products_target
)
select * from row_count_dynamic(base)
/