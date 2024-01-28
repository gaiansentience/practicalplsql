--compare row differences with union and minus using CTE
with source_table as (
    select --+ materialize
        s.* 
    from products_source s
), target_table as (
    select --+ materialize
        t.* 
    from products_target t
)
select u.* 
from
    (
        (
            select 'source' as row_source, s.* from source_table s
            minus
            select 'source' as row_source, t.* from target_table t
        )
        union all
        (
            select 'target' as row_source, t.* from target_table t
            minus
            select 'target' as row_source, s.* from source_table s
        )
    ) u
order by u.product_id, u.row_source
/

