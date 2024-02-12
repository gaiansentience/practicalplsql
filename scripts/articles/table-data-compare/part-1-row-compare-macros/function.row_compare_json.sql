create or replace function row_compare_json(
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
select 
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.##ID_COLUMN##, t.##ID_COLUMN##) as ##ID_COLUMN##,
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , ##ID_COLUMN##
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , ##ID_COLUMN##
            , json_object(*) as jdoc 
        from p_target    
    ) t
        on s.##ID_COLUMN## = t.##ID_COLUMN##
        and json_equal(s.jdoc, t.jdoc)
where 
    s.##ID_COLUMN## is null 
    or t.##ID_COLUMN## is null
order by ##ID_COLUMN##, row_source
]';

    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));
    
    dbms_output.put_line(l_sql);
    
    return l_sql;

end row_compare_json;
/
