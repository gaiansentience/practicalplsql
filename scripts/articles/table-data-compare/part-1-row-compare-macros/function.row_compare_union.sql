create or replace function row_compare_union(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t,
    p_order_columns in dbms_tf.columns_t  default null
) return varchar2
sql_macro $if dbms_db_version.version >= 21 $then (table) $end
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
select u.* 
from (
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
]';

    if p_order_columns is not null then
        l_sql := l_sql || ' order by ';
        for i in 1..p_order_columns.count loop
            l_sql := l_sql || 'u.' || p_order_columns(i) || ',';
        end loop;
        l_sql := l_sql || ' u.row_source';
    end if;

    dbms_output.put_line(l_sql);
    return l_sql;
    
end row_compare_union;
/