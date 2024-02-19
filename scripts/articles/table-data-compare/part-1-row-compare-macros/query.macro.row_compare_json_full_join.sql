--compare row differences with json and full outer join using macro
select *
from row_compare_json(products_source, products_target, columns(product_id))
/
