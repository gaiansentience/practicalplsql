--compare row differences with union and minus
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
        select *
        from
        (
            select 'target' as row_source, t.* 
            from products_target t
            minus
            select 'target' as row_source, s.* 
            from products_source s
        )
    ) u
order by u.product_id, u.row_source
/
