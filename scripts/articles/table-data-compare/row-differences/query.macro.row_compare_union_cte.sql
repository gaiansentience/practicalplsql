--compare row differences with union and minus cte using macro
select *
from row_compare_union_cte(products_source, products_target, columns(product_id))
/

select *
from row_compare_union_cte(products_source, products_target, columns(code))
/


select *
from row_compare_union_cte(products_source, products_target)
/
