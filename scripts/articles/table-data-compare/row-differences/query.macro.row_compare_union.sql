--compare row differences with union and minus using macro
select * from row_compare_union(products_source, products_target, columns(product_id));

select * from row_compare_union(products_source, products_target, columns(code));

select * from row_compare_union(products_source, products_target);

with source_rows as (
    select /*+ materialize */ *
    from products_source
), target_rows as (
    select /*+ materialize */ *
    from products_target
)
select * from row_compare_union(source_rows, target_rows, columns(product_id));