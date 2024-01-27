set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
        select count(*) as difference_count 
        from get_row_compare_union_minus(products_source, products_target)
    '
    into i;
    dbms_output.put_line(i || ' differences found');
end;
/

/*
        with source_table as (
            select * from p_source
        ), target_table as (
            select * from p_target
        ), source_only as (
            select 'source' as row_source, s.* from source_table s
            minus
            select 'source' as row_source, t.* from target_table t
        ), target_only as (
            select 'target' as row_source, t.* from target_table t
            minus
            select 'target' as row_source, s.* from source_table s
        )
        select * from source_only
        union all
        select * from target_only

10 differences found

*/