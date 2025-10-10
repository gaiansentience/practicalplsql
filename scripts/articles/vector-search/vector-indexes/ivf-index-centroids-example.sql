

create table test_vectors (
    v vector(2,float32)
)
/

create vector index test_vectors_ivf
    on test_vectors(v)
    organization neighbor partitions
    distance cosine
    parameters (
        type ivf,
        neighbor partitions 10,
        min_vectors_per_partition 0)
/


select * from user_tables
where table_name like '%TEST_VECTORS%';



create or replace procedure show_counts(base_table in varchar2)
is
    n number;
    sql_template constant varchar2(1000) :=
        q'!
        select count(*) from ##T##
        !';
begin
    for r in (
        select table_name from user_tables
        where table_name like '%' || upper(base_table) || '%'
        ) loop
        
        execute immediate replace(sql_template, '##T##', r.table_name)
        into n;
        
        dbms_output.put_line(n || ' rows in ' || r.table_name);
    end loop;
    
end show_counts;
/

create or replace procedure show_centroids(base_table in varchar2)
is
    centroids_table varchar2(128);
    sql_template varchar2(1000) :=
        q'!
        select
            from_vector(centroid_vector) as centroid_text
            from ##CT##
        !';
    cv sys_refcursor;        
    type t_strings is table of varchar2(4000);
    centroids t_strings;
begin
    select table_name
    into centroids_table
    from user_tables 
    where table_name like '%' || upper(base_table) || '%' || 'IVF_FLAT_CENTROIDS';
    
    open cv for replace(sql_template, '##CT##', centroids_table);
    fetch cv bulk collect into centroids;
    close cv;
    
    dbms_output.put_line(centroids.count || ' centroids defined:');
    
    for i in indices of centroids loop
        dbms_output.put_line(centroids(i));
    end loop;
    
end show_centroids;
/

create or replace procedure show_centroid_partitions(base_table in varchar2)
is
    centroids_table varchar2(128);
    centroid_partitions_table varchar2(128);
    sql_template constant varchar2(4000) :=
        q'!
        select 'centroid ' || c.centroid_id || ') '
            || from_vector(centroid_vector)
            || '  -  '
            || from_vector(data_vector)
            as index_detail
        from ##C## c join ##CP## p on c.centroid_id = p.centroid_id
        order by c.centroid_id
        !';
    cv sys_refcursor;        
    type t_strings is table of varchar2(4000);
    index_details t_strings;        
begin
    select table_name into centroids_table
    from user_tables 
    where table_name like '%' || upper(base_table) || '%' || 'IVF_FLAT_CENTROIDS';
    
    select table_name into centroid_partitions_table
    from user_tables 
    where table_name like '%' || upper(base_table) || '%' || 'IVF_FLAT_CENTROID_PARTITIONS';
    
    open cv for replace(replace(sql_template,'##C##', centroids_table),'##CP##', centroid_partitions_table);

    fetch cv bulk collect into index_details;
    close cv;
    
    for i in indices of index_details loop
        dbms_output.put_line(index_details(i));
    end loop;
    
end show_centroid_partitions;
/


set serveroutput on;

exec show_counts('test_vectors');

insert into test_vectors
with base (v_text) as (
    values ('[-2,-2]'),('[2,2]'), ('[2,-2]'), ('[-2,2]')
), v_base as (
    select to_vector(v_text,2,float32) as v
    from base
)
select v
from v_base
/


insert into test_vectors(v)
select to_vector(v_text,2,float32) as v
from 
    (values ('[-2,-2]'),('[2,2]'), ('[2,-2]'), ('[-2,2]')
    ) v_base (v_text) 
/

insert into test_vectors(v) values ('[-2,-2]'),('[2,2]'), ('[2,-2]'), ('[-2,2]')
/

insert into test_vectors(v) values (vector('[10,10]',2,float32));

exec show_centroids('test_vectors');

exec dbms_vector.rebuild_index('TEST_VECTORS_IVF');

alter index test_vectors_ivf rebuild online;

delete test_vectors;

commit;


exec show_centroid_partitions('test_vectors');