create or replace function get_row_compare(
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
    coalesce(s.src_tbl, t.src_tbl) as src_tbl
]';
for i in 1..p_id_column.count loop
    l_sql := l_sql || ', coalesce(s.' || p_id_column(i) || ', t.' || p_id_column(i) || ') as ' || p_id_column(i);
end loop;
--    , coalesce(s.id, t.id) as id
l_sql := l_sql || q'[
, coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'src' as src_tbl
]';
for i in 1..p_id_column.count loop
    l_sql := l_sql || ', ' || p_id_column(i);
end loop;
--            , ]' || p_id_column(1) || q'[ as id
l_sql := l_sql || q'[
            , json_object(*) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'tgt' as src_tbl
]';
for i in 1..p_id_column.count loop
    l_sql := l_sql || ', ' || p_id_column(i);
end loop;
--            , ]' || p_id_column(1) || q'[ as id
l_sql := l_sql || q'[
            , json_object(*) as jdoc 
        from p_target    
    ) t
        on ]';
for i in 1..p_id_column.count loop
    l_sql := l_sql || case when i > 1 then ' AND ' end || 's.' || p_id_column(i) || ' = t.' || p_id_column(i);
end loop;
--        s.id = t.id
l_sql := l_sql || q'[        
        and json_equal(s.jdoc, t.jdoc)
where  
s.]' || p_id_column(1) || ' is null or t.' || p_id_column(1) || ' is null';
--s.id is null or t.id is null    
--]';
    dbms_output.put_line(l_sql);
    return l_sql;
end get_row_compare;
/