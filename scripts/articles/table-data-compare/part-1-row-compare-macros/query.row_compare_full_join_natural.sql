--compare row differences with natural full outer join
--does not support clobs
--equality join is not null aware
--identical rows with a null column will show as differences
select *
from   
    (
        select 
            'source' as row_source_s
            , s.*
        from products_source s   
    ) s
    natural full outer join (
        select 
            'target' as row_source_t
            , t.*
        from products_target t   
    ) t
where 
    row_source_s is null 
    or row_source_t is null
order by product_id
/
