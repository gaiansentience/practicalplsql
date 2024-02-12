create or replace function row_compare_union(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t,
    p_id_column in dbms_tf.columns_t  
) return varchar2
sql_macro (table)
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
select u.* 
from
    (
        (
            select 'source' as row_source, s.* 
            from products_source s
            minus
            select 'source' as row_source, t.* 
            from products_target t
        )
        union all
        (
            select 'target' as row_source, t.* 
            from products_target t
            minus
            select 'target' as row_source, s.* 
            from products_source s
        )
    ) u
order by u.##ID_COLUMN##, u.row_source
]';

    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));

    dbms_output.put_line(l_sql);
    
    return l_sql;
    
end row_compare_union;
/