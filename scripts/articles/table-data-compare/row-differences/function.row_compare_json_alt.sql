create or replace function row_compare_json_alt(
    p_source in dbms_tf.table_t, 
    p_target in dbms_tf.table_t, 
    p_id_column in dbms_tf.columns_t
) return varchar2
sql_macro $if dbms_db_version.version >= 21 $then (table) $end
is
    c_lf constant varchar2(1) := chr(10);
    l_sql varchar2(4000);
    l_ids varchar2(4000);
    l_coalesce varchar2(4000);
    l_joins varchar2(4000);
    l_json_object varchar2(100);    
begin

$if dbms_db_version.version = 19 $then
    l_json_object := 'json_object(* returning clob)';
$else
    l_json_object := 'json_object(* returning json)';
$end

    for i in 1..p_id_column.count loop
        l_coalesce := l_coalesce 
            || case when i > 1 then '    ' end 
            || ', coalesce(s.' || p_id_column(i) 
            || ', t.' || p_id_column(i) 
            || ') as ' || p_id_column(i) || c_lf;
    end loop;
    l_coalesce := trim(trailing c_lf from l_coalesce);
    
    for i in 1..p_id_column.count loop
        l_ids := l_ids 
            || case when i > 1 then '            , ' else ', ' end 
            || p_id_column(i) || c_lf;
    end loop;
    l_ids := trim(trailing c_lf from l_ids);
    
    for i in 1..p_id_column.count loop
        l_joins := l_joins 
            || case when i > 1 then '        and ' end 
            || 's.' || p_id_column(i) 
            || ' = t.' || p_id_column(i) || c_lf;
    end loop;
    l_joins := trim(trailing c_lf from l_joins);

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
            , ##JSON_OBJECT## as jdoc 
        from p_source    
    ) s
    full outer join 
    (
        select 
            'target' as row_source
            ##ID_COLUMNS##
            , ##JSON_OBJECT## as jdoc 
        from p_target    
    ) t 
        on ##JOIN_COLUMNNS##
        and json_equal(s.jdoc, t.jdoc)
where s.##ID_COLUMN_ONE## is null or t.##ID_COLUMN_ONE## is null
order by ##ID_COLUMN_ONE##, row_source
]';

    l_sql := replace(l_sql, '##COALESCE_COLUMNS##', l_coalesce);
    l_sql := replace(l_sql, '##ID_COLUMNS##', l_ids);
    l_sql := replace(l_sql, '##JOIN_COLUMNNS##', l_joins);
    l_sql := replace(l_sql, '##ID_COLUMN_ONE##', p_id_column(1));
    l_sql := replace(l_sql, '##JSON_OBJECT##', l_json_object);

    dbms_output.put_line(l_sql);
    
    return l_sql;

end row_compare_json_alt;
/
