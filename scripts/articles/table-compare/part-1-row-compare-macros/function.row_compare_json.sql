create or replace function row_compare_json(
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
select 
    coalesce(s.id, t.id) as id,
    coalesce(s.row_source, t.row_source) as row_source, 
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , ]' || p_id_column(1) || q'[ as id
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , ]' || p_id_column(1) || q'[ as id
            , json_object(*) as jdoc 
        from p_target    
    ) t
        on s.id = t.id
        and json_equal(s.jdoc, t.jdoc)
where s.id is null or t.id is null    
]';
    dbms_output.put_line(l_sql);
    return l_sql;
end row_compare_json;
/
