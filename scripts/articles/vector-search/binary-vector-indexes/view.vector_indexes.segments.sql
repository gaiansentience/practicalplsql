

select
      regexp_substr(s.segment_name,'^(VECTOR[\$])(.*)([\$].*[\$].*)$',1,1,'i',2) as idx_name
    , regexp_substr(s.segment_name,'^(VECTOR[\$])(.*)([\$].*[\$])(IVF_FLAT_)(.*)$',1,1,'i',5) as idx_structure
    , count(distinct s.partition_name) as idx_partitions
    , sum(bytes) /1024/1024 as sum_mb
from user_segments s
where s.segment_name like 'VECTOR$MENU_VECTORS%'
group by idx_name, rollup(idx_structure)
order by idx_name, idx_structure asc nulls last
/

with function get_rowcount(p_table in varchar2) return number
is
    n number;
begin

    execute immediate 'select count(*) from ' || p_table
    into n;
    
    return n;
end get_rowcount;

select  
    table_name
    , get_rowcount(table_name) as rws
from user_tables
where table_name not like 'DM$%'
/
