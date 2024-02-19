--compare row differences with union and minus using macro
select *
from row_compare_union(products_source, products_target, columns(product_id))
/
