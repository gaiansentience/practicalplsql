prompt 3.2-test-combining-macro.sql
prompt there is no syntax option to combine table macros

prompt restriction of macros inside of CTE expressions prevents simple nested calls

with base as (
    select  product_id, code, name, msrp
    from products_source
    order by product_id
    fetch first 2 rows only
), converted_datatypes as (
    select product_id, code, name, msrp
    from convert_columns_to_varchar(base, columns(product_id, code))
)
select *
from dynamic_unpivot_columns(converted_datatypes, columns(product_id, code))
/
--ORA-64630: unsupported use of SQL macro: use of SQL macro inside WITH clause is not supported


prompt we are using dbms_tf.table_t to pass the data source, this can only accept a table name or CTE expression name
prompt nesting the macro calls will not work
prompt there is no equivalent to CURSOR() that is used to chain pipelined functions together

with base as (
    select  product_id, code, name, msrp
    from products_source
    order by product_id
    fetch first 2 rows only
)
select * 
from dynamic_unpivot_columns(
    convert_columns_to_varchar(base, columns(product_id, code))
    , columns(product_id, code))
/
--ORA-64629: table SQL macro can only appear in FROM clause of a SQL statement