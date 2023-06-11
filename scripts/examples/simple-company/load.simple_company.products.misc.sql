
insert into sc#product_categories (product_category_name)
with n_base as (select level as n from dual connect by level <= 7)
select case n when 1 then 'Appliances' when 2 then 'Computers' when 3 then 'Clothing' when 4 then 'Gardening' 
    when 5 then 'Automotive' when 6 then 'Kitchenware' when 7 then 'Furniture'
    end as product_category_name 
from n_base where n <> 2;

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 9)
select
    case b.n 
        when 1 then 'Toasters' when 2 then 'Coffeemakers' when 3 then 'Blenders' when 4 then 'Microwave Ovens' when 5 then 'Refrigerators' 
        when 6 then 'Ranges' when 7 then 'Washing Machines' when 8 then 'Dryers' when 9 then 'Air Systems' 
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Appliances';

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 8)
select
    case b.n 
        when 1 then 'Shirts' when 2 then 'Shorts' when 3 then 'Pants' when 4 then 'Skirts' when 5 then 'Dresses' 
        when 6 then 'Socks' when 7 then 'Coats' when 8 then 'Hats' 
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Clothing';

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 8)
select
    case b.n 
        when 1 then 'Tools' when 2 then 'Seeds' when 3 then 'Pots' when 4 then 'Soil' when 5 then 'Soil Amendments' 
        when 6 then 'Pest Prevention' when 7 then 'Plants' when 8 then 'Garden Decor' 
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Gardening';

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 4)
select
    case b.n 
        when 1 then 'Batteries' when 2 then 'Tires' when 3 then 'Stereos' when 4 then 'Chargers'
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Automotive';

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 6)
select
    case b.n 
        when 1 then 'Pots' when 2 then 'Pans' when 3 then 'Utensils' when 4 then 'Dishes' when 5 then 'Glassware' when 6 then 'Gadgets'
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Kitchenware';

insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 4)
select
    case b.n 
        when 1 then 'Beds' when 2 then 'Chairs' when 3 then 'Tables' when 4 then 'Desks'
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Furniture';

