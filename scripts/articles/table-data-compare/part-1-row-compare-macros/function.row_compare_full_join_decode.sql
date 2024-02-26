create or replace function row_compare_full_join_decode(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro $if dbms_db_version.version >= 21 $then (table) $end
is
    c_lf       constant varchar2(1) := chr(10);
    l_sql      varchar2(32000);
    l_column   dbms_tf.column_metadata_t;
    l_coalesce varchar2(4000);
    l_joins    varchar2(4000);
begin

    for i in 1..p_source.column.count loop
        l_column := p_source.column(i).description;
        l_coalesce := l_coalesce 
            || case when i > 1 then '    ' end
            || ', coalesce(s.' || l_column.name
            || ', t.' || l_column.name
            || ') as ' || l_column.name || c_lf;
    end loop;
    l_coalesce := trim(trailing c_lf from l_coalesce);
        
    for i in 1..p_source.column.count loop
        l_column := p_source.column(i).description;
        l_joins := l_joins 
            || case when i > 1 then '        and ' end
            || case
            when l_column.name member of p_id_column then
                's.' || l_column.name || ' = t.' || l_column.name
            when l_column.type = dbms_tf.type_clob then
                'dbms_lob.compare(s.' || l_column.name || ', t.' || l_column.name || ') = 1'
            else
                'decode(s.' || l_column.name || ', t.' || l_column.name || ', 1, 0) = 1'
            end || c_lf;
    end loop;
    l_joins := trim(trailing c_lf from l_joins);

    l_sql := 
q'[
select 
    coalesce(s.row_source, t.row_source) as row_source
    ##COALESCE_COLUMNS##
from   
    (
        select 'source' as row_source, src.* from p_source src   
    ) s
    full outer join (
        select 'target' as row_source, tgt.* from p_target tgt
    ) t
        on ##JOIN_COLUMNNS##
where 
    s.##ID_COLUMN## is null or t.##ID_COLUMN## is null
order by ##ID_COLUMN##, row_source
]';

    l_sql := replace(l_sql, '##COALESCE_COLUMNS##', l_coalesce);
    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));
    l_sql := replace(l_sql, '##JOIN_COLUMNNS##', l_joins);
    
    dbms_output.put_line(l_sql);
    
    return l_sql;

end row_compare_full_join_decode;
/
