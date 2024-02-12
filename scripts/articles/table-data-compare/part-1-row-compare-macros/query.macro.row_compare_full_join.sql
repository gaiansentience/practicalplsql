--compare row differences with full outer join using macro and null aware decode join
select *
from row_compare_full_join(products_source, products_target, columns(product_id))
/
