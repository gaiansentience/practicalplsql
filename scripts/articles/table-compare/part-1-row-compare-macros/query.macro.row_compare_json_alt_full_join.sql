--compare row differences with json and full outer join using macro with multiple id columns
select * from row_compare_json_alt(products_source, products_target, columns(product_id, code))
/
