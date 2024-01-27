create or replace function get_row_compare_union_minus(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t
) return varchar2
sql_macro(table)
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
        with source_table as (
            select * from p_source
        ), target_table as (
            select * from p_target
        ), source_only as (
            select 'source' as row_source, s.* from source_table s
            minus
            select 'source' as row_source, t.* from target_table t
        ), target_only as (
            select 'target' as row_source, t.* from target_table t
            minus
            select 'target' as row_source, s.* from source_table s
        )
        select * from source_only
        union all
        select * from target_only
]';

    dbms_output.put_line(l_sql);
    return l_sql;
end get_row_compare_union_minus;
/