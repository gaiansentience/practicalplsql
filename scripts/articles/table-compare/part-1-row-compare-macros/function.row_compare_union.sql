create or replace function row_compare_union(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t
) return varchar2
sql_macro(table)
is
    l_sql varchar2(32000);
begin

    l_sql := 
q'[
        (
            select 'source' as row_source, s.* from p_source s
            minus
            select 'source' as row_source, t.* from p_target t
        )
        union all
        (
            select 'target' as row_source, t.* from p_target t
            minus
            select 'target' as row_source, s.* from p_source s
        )
]';

    dbms_output.put_line(l_sql);
    
    return l_sql;
    
end row_compare_union;
/