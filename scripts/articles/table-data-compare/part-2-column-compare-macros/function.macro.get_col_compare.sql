create or replace function get_column_compare(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro(table)
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
with source_columns as (
select u.*
from
    (
        select json_object(*) as jdoc 
        from p_source 
    ) s,
    table(dynamic_json_table.unpivot_json(s.jdoc,']' || trim(both '"' from p_id_column(1)) || q'[')) u
), target_columns as (
select u.*
from
    (
        select json_object(*) as jdoc 
        from p_target
    ) s,
    table(dynamic_json_table.unpivot_json(s.jdoc,']' || trim(both '"' from p_id_column(1)) || q'[')) u
)
select 
    c.id
    , c.src_tbl
    , json_value(c.jdoc,'$.key.string()') as key
    , json_value(c.jdoc,'$.value.string()') as value
from 
    get_row_compare(source_columns, target_columns, columns("id")) c
]';
    dbms_output.put_line(l_sql);
    return l_sql;
end get_column_compare;
/