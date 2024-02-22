create or replace function row_compare_full_join_decode(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro (table)
is
    c_lf constant varchar2(1) := chr(10);
    l_sql varchar2(32000);
    l_col varchar2(1000);
    l_coalesce_columns varchar2(4000);
    l_join_columns varchar2(4000);
begin

    for i in 1..p_source.column.count loop
        l_col := p_source.column(i).description.name;
        l_coalesce_columns := l_coalesce_columns 
            || case when i > 1 then '    ' end || ', coalesce(s.' || l_col
            || ', t.' || l_col
            || ') as ' || l_col || c_lf;
    end loop;
    l_coalesce_columns := trim(trailing c_lf from l_coalesce_columns);
        
    for i in 1..p_source.column.count loop
        l_col := p_source.column(i).description.name;
        l_join_columns := l_join_columns 
            || case when i > 1 then '        and ' end 
            || case when l_col member of p_id_column then
                    's.' || l_col || ' = t.' || l_col
                else
                    case when p_source.column(i).description.type = dbms_tf.TYPE_CLOB then
                        'dbms_lob.compare(s.'||l_col ||', t.' || l_col||') = 1'
                    else
                        'decode(s.' || l_col || ', t.' || l_col || ', 1, 0) = 1'
                    end
                end || c_lf;
    end loop;
    l_join_columns := trim(trailing c_lf from l_join_columns);

    l_sql := 
q'[
select 
    coalesce(s.row_source, t.row_source) as row_source
    ##COALESCE_COLUMNS##
from   
    (
        select 
            'source' as row_source
            , s.*
        from p_source s   
    ) s
    full outer join (
        select 
            'target' as row_source
            , t.*
        from p_target t
    ) t
        on ##JOIN_COLUMNNS##
where 
    s.##ID_COLUMN## is null 
    or t.##ID_COLUMN## is null
order by ##ID_COLUMN##, row_source
]';

    l_sql := replace(l_sql, '##COALESCE_COLUMNS##', l_coalesce_columns);
    l_sql := replace(l_sql, '##ID_COLUMN##', p_id_column(1));
    l_sql := replace(l_sql, '##JOIN_COLUMNNS##', l_join_columns);
    
    dbms_output.put_line(l_sql);
    
    return l_sql;

end row_compare_full_join_decode;
/
