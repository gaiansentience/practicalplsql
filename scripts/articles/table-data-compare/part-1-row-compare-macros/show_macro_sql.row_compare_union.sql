set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    execute immediate '
        select count(*) as difference_count 
        from row_compare_union(products_source, products_target, columns(product_id))
    '
    into i;
    dbms_output.put_line(i || ' differences found');
end;
/

/*

select u.* 
from
    (
        (
            select 'source' as row_source, s.* 
            from products_source s
            minus
            select 'source' as row_source, t.* 
            from products_target t
        )
        union all
        (
            select 'target' as row_source, t.* 
            from products_target t
            minus
            select 'target' as row_source, s.* 
            from products_source s
        )
    ) u
order by u."PRODUCT_ID", u.row_source

13 differences found


PL/SQL procedure successfully completed.

*/