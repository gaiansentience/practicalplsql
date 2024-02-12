create or replace function row_compare_union_cte(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t
$if dbms_db_version.version >= 21 $then
    , p_id_column in dbms_tf.columns_t 
$end
) return varchar2
sql_macro
$if dbms_db_version.version >= 21 $then 
    (table)
$end
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
with source_table as (
    select --+ materialize
        s.* 
    from p_source s
), target_table as (
    select --+ materialize
        t.* 
    from p_target t
)
select u.* 
from
    (
        (
            select 'source' as row_source, s.* 
            from source_table s
            minus
            select 'source' as row_source, t.* 
            from target_table t
        )
        union all
        (
            select 'target' as row_source, t.* 
            from target_table t
            minus
            select 'target' as row_source, s.* 
            from source_table s
        )
    ) u
]';

$if dbms_db_version.version >= 21 $then
    l_sql := l_sql || 'order by u.##ID_COLUMN##, u.row_source';
    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));
$end
    dbms_output.put_line(l_sql);

    return l_sql;

end row_compare_union_cte;
/