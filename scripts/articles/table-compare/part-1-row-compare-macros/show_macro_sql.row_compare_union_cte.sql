set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
        select count(*) as difference_count 
        from row_compare_union_cte(products_source, products_target, columns(product_id))
    '
    into i;
    dbms_output.put_line(i || ' differences found');
end;
/

/*
with source_table as (
    select --+ materialize  
    s.* 
    from p_source s
), target_table as (
    select --+ materialize  
    t.* 
    from p_target t
)
select u.* 
from
    (
        (
            select 'source' as row_source, s.* 
            from source_table s
            minus
            select 'source' as row_source, t.* 
            from target_table t
        )
        union all
        (
            select 'target' as row_source, t.* 
            from target_table t
            minus
            select 'target' as row_source, s.* 
            from source_table s
        )
    ) u
order by u."PRODUCT_ID", u.row_source

*/