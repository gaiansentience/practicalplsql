column category_name format a20
set pagesize 100

select
    case grouping_id(c.category_name) when 1 then 'All Categories' else c.category_name end as category_name
    , count(*) as item_count
    , trunc(avg(length(i.item_description))) as avg_item_description_length
from menu_items i
join menu_categories c using (category_id)
group by rollup (c.category_name)
order by grouping(c.category_name), c.category_name
/