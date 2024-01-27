create or replace function get_row_compare_alt(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro(table)
is
    c_lf constant varchar2(1) := chr(10);
    subtype t_sql is varchar2(4000);
    l_sql t_sql;
    l_id_columns t_sql;
    l_coalesce_columns t_sql;
    l_join_columns t_sql;
begin

    for i in 1..p_id_column.count loop
        l_coalesce_columns := l_coalesce_columns || '    , coalesce(s.' || p_id_column(i) || ', t.' || p_id_column(i) || ') as ' || p_id_column(i) || c_lf;
    end loop;
    l_coalesce_columns := trim(trailing c_lf from l_coalesce_columns);
    
    for i in 1..p_id_column.count loop
        l_id_columns := l_id_columns || '            , ' || p_id_column(i) || c_lf;
    end loop;
    l_id_columns := trim(trailing c_lf from l_id_columns);
    
    for i in 1..p_id_column.count loop
        l_join_columns := l_join_columns || '        ' || case when i > 1 then 'and ' end || 's.' || p_id_column(i) || ' = t.' || p_id_column(i) || c_lf;
    end loop;
    l_join_columns := trim(trailing c_lf from l_join_columns);

    l_sql := 
q'[
select 
    coalesce(s.row_source, t.row_source) as row_source
    ##COALESCE_COLUMNS##
    , coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            ##ID_COLUMNS##
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join 
    (
        select 
            'target' as row_source
            ##ID_COLUMNS##
            , json_object(*) as jdoc 
        from p_target    
    ) t 
        on ##JOIN_COLUMNNS##
        and json_equal(s.jdoc, t.jdoc)
where 
    s.]' || p_id_column(1) || ' is null 
    or t.' || p_id_column(1) || ' is null';

    l_sql := replace(l_sql, '##COALESCE_COLUMNS##', l_coalesce_columns);
    l_sql := replace(l_sql, '##ID_COLUMNS##', l_id_columns);
    l_sql := replace(l_sql, '##JOIN_COLUMNNS##', l_join_columns);

    dbms_output.put_line(l_sql);
    
    return l_sql;

end get_row_compare_alt;
/
