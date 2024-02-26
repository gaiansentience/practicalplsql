create or replace function row_compare_json(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro $if dbms_db_version.version >= 21 $then (table) $end
is
    l_sql varchar2(32000);
    l_json_object varchar2(100);
begin

$if dbms_db_version.version = 19 $then
    l_json_object := 'json_object(* returning clob)';
$else
    l_json_object := 'json_object(* returning json)';
$end

    l_sql := 
q'[
select 
    coalesce(s.row_source, t.row_source) as row_source, 
    --coalesce(s.##ID_COLUMN##, t.##ID_COLUMN##) as ##ID_COLUMN##,
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , ##ID_COLUMN##
            , ##JSON_OBJECT## as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , ##ID_COLUMN##
            , ##JSON_OBJECT## as jdoc 
        from p_target    
    ) t
        on s.##ID_COLUMN## = t.##ID_COLUMN##
        and json_equal(s.jdoc, t.jdoc)
where s.##ID_COLUMN## is null or t.##ID_COLUMN## is null
order by coalesce(s.##ID_COLUMN##, t.##ID_COLUMN##), row_source
]';

    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));
    l_sql := replace(l_sql, '##JSON_OBJECT##', l_json_object);
    
    dbms_output.put_line(l_sql);
    
    return l_sql;

end row_compare_json;
/
