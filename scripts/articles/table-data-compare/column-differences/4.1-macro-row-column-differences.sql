prompt 4.1-macro-row-column-differences.sql
prompt create a simple macro to compare row and column differences
prompt no syntax options for passing results of one macro call to another macro
prompt cannot reuse find_row_differences macro

create or replace function find_row_column_differences(
    source_data in dbms_tf.table_t
    , target_data in dbms_tf.table_t
    , id_columns in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_sql varchar2(4000);
    l_id_columns varchar2(4000);
begin
    select listagg(column_value,',') 
    into l_id_columns 
    from table(id_columns);
    
    l_sql := q'!
    select *
    from find_row_differences(
        dynamic_unpivot_columns(source_data, columns(##ID_COLUMNS##))
        , dynamic_unpivot_columns(target_data, columns(##ID_COLUMNS##))
        , columns(##ID_COLUMNS##))
    !';
    
    l_sql := replace(l_sql,'##ID_COLUMNS##', l_id_columns);
    
    return l_sql;
end find_row_column_differences;
/

prompt test the macro to show row and column differences
select * from find_row_column_differences(products_source, products_target, columns(product_id, code))
/

--SQL Error: ORA-64629: table SQL macro can only appear in FROM clause of a SQL statement