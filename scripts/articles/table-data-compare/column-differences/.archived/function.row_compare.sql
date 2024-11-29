create or replace function row_compare(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_columns in dbms_tf.columns_t
) return varchar2
sql_macro(table)
is
    l_sql varchar2(32000);
    l_column varchar2(128);
    l_id_columns varchar2(4000);
    l_coalesce_columns varchar2(4000);
    l_join_columns varchar2(4000); 
begin

    for i in 1..p_id_columns.count loop
    
        l_column := p_id_columns(i);
        
        l_coalesce_columns := l_coalesce_columns 
            || ', coalesce(s.' || l_column || ', t.' || l_column || ') as ' || l_column;
            
        l_id_columns := l_id_columns 
            || ', ' || l_column;
        
        l_join_columns := l_join_columns
            || case when i > 1 then ' and ' end
            || 's.' || l_column || ' = t.' || l_column;
            
    end loop;

    l_sql := 
q'[
select 
    coalesce(s.row_source, t.row_source) as row_source
    ##COALESCE_COLUMNS##
    , coalesce(s.jrow, t.jrow) as jrow
from   
    (
        select 
            'source' as row_source
            ##ID_COLUMNS##
            , json_object(*) as jrow 
        from p_source    
    ) s
    full outer join 
    (
        select 
            'target' as row_source
            ##ID_COLUMNS##
            , json_object(*) as jrow 
        from p_target    
    ) t 
        on ##JOIN_COLUMNNS##
        and json_equal(s.jrow, t.jrow)
where s.##ID_COLUMN_ONE## is null or t.##ID_COLUMN_ONE## is null
order by ##ID_COLUMN_ONE##, row_source
]';

    l_sql := replace(l_sql, '##COALESCE_COLUMNS##', l_coalesce_columns);
    l_sql := replace(l_sql, '##ID_COLUMNS##', l_id_columns);
    l_sql := replace(l_sql, '##JOIN_COLUMNNS##', l_join_columns);
    l_sql := replace(l_sql, '##ID_COLUMN_ONE##', p_id_columns(1));

    return l_sql;

end row_compare;
/
