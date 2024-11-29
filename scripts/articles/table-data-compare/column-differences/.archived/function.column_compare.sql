create or replace function column_compare(
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
        select json_object(* returning json) as jdoc 
        from p_source 
    ) s,
    table(dynamic_json.unpivot_json_array(s.jdoc,']' || trim(both '"' from p_id_column(1)) || q'[')) u
), target_columns as (
select u.*
from
    (
        select json_object(* returning json) as jdoc 
        from p_target
    ) s,
    table(dynamic_json.unpivot_json_array(s.jdoc,']' || trim(both '"' from p_id_column(1)) || q'[')) u
)
select 
    c."ROW#ID"
    , c."COLUMN#KEY"
    , c.row_source
    , json_value(c.jdoc,'$.COLUMN#VALUE.string()') as value
from 
    row_compare(source_columns, target_columns, columns("ROW#ID","COLUMN#KEY")) c
]';
    dbms_output.put_line(l_sql);
    return l_sql;
end column_compare;
/