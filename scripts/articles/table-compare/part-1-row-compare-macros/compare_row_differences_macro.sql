--compare row differences using sql table macro with full outer join and json
select *
from 
    get_row_compare(products_source,products_target, columns(product_id))
/

--compare row differences using sql table macro with full outer join and json passing multiple identifier columns
select *
from 
    get_row_compare_alt(products_source,products_target, columns(product_id, code))
/

--compare row differences using sql table macro with minus and union
select *
from 
    get_row_compare_union_minus(products_source,products_target)
/

