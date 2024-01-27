--compare row differences with union and minus
with source_table as (
    select * 
    from products_source
), target_table as (
    select * 
    from products_target
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
/
