
insert into sc#product_categories (product_category_name)
with n_base as (select level as n from dual connect by level <= 7)
select case n when 1 then 'Appliances' when 2 then 'Computers' when 3 then 'Clothing' when 4 then 'Gardening' 
    when 5 then 'Automotive' when 6 then 'Kitchenware' when 7 then 'Furniture'
    end as product_category_name 
from n_base where n = 2;


insert into sc#product_types (product_type_name, product_category_id)
with n_base as (select level as n from dual connect by level <= 10)
select
    case b.n 
        when 1 then 'Desktops' when 2 then 'Notebooks' when 3 then 'Servers' when 4 then 'Monitors' when 5 then 'Power Management' 
        when 6 then 'Networking' when 7 then 'Accessories' when 8 then 'Printers' when 9 then 'Operating Systems' when 10 then 'Application Software'
        end as product_type_name
    , c.product_category_id
from n_base b cross join sc#product_categories c
where c.product_category_name = 'Computers';

insert into sc#products (product_code, product_name, product_description, product_type_id, msrp_price)
with n_base as (select level as n from dual connect by level <= 12
), system_cores as (select case when n = 9 then 24 when n = 10 then 40 when n = 11 then 14 else power(2,n - 1) end as cores from n_base where n <= 11
), system_ram_speed as (
select n as ram_code, 'DDR' || n as ram_type, (n * 1100)  || ' Mhz' as ram_speed, n * 1.50 || '-' || n * 2.500 || ' Thz' as chipset_speed, case n when 7 then .7 when 8 then 1 when 9 then 1.3 end as ram_modifier
from n_base where n between 7 and 9
), system_ram as (
select s.ram_code, s.ram_type, s.ram_speed, chipset_speed, s.ram_modifier, power(2,b.n) as gb 
from n_base b cross join system_ram_speed s where b.n between 2 and 9
), system_hdd as (select case n when 1 then .5 when 2 then 1 when 3 then 2 when 4 then 4  when 5 then 6 when 6 then 8 when 7 then 10 when 8 then 12 when 9 then 16 when 10 then 20 when 11 then 36 when 12 then 40 end as tb from n_base
), form_factors as (
select 
case when n in (1,2,3,4) then 'Notebooks' when n in (5,6,7,8) then 'Desktops' when n in (9,10,11) then 'Servers' end as product_type_name
, case n when 1 then .9 when 2 then 1 when 3 then 1.1 when 4 then 1.2
when 5 then .8 when 6 then .9 when 7 then 1 when 8 then 1.1 
when 9 then 1.1 when 10 then 1 when 11 then .9 end as price_modifier
,case n when 1 then '14 inch Notebook' when 2 then '15 inch Notebook' when 3 then '16 inch Notebook' when 4 then '17 inch Notebook' 
when 5 then 'Micro Desktop' when 6 then 'Compact Desktop' when 7 then 'Mid Tower Desktop' when 8 then 'Tower Desktop' 
when 9 then 'Compact Server' when 10 then 'Tower Server' when 11 then 'Rack Mount Server' end as ff_description 
,case n when 1 then '14C' when 2 then '15A' when 3 then '16L' when 4 then '17LX' 
when 5 then 'MZ' when 6 then 'CQ' when 7 then 'TE' when 8 then 'TS' 
when 9 then 'SC' when 10 then 'STX' when 11 then 'SRX' end as ff_code
from n_base where n <= 11
), base_systems as (
select
t.product_type_id
, t.product_type_name
, ff.ff_description
, ff.ff_code || sr.ram_code || to_char(sc.cores,'fm099') || to_char(sr.gb,'fm099') || sh.tb * 1000 as product_code
, case when t.product_type_name = 'Notebooks' then 
case round(cores/4) when 0 then 'Pixie' when 1 then 'Shark' when 2 then 'Elemental' when 4 then 'Dragon' when 6 then 'Phoenix' else 'undefined' end
|| ' ' || (((round(cores/4)+1) * 1000) + cores) || 'N'
when t.product_type_name = 'Desktops' then 
case round(cores/6) when 1 then 'Brickton' when 2 then 'Urbana' when 3 then 'Navigator' when 4 then 'Solaria' else 'Galactron' end
|| ' ' ||  (((round(cores/4)+3) * 1000) + cores) || 'L'
when t.product_type_name = 'Servers' then 
case round(cores/16) when 1 then 'Paris' when 2 then 'Copenhagen' when 3 then 'Rio' when 4 then 'Fuji' else 'Everest' end
|| ' ' ||  (((round(cores/4)+5) * 1000) + cores) || 'U' 
end || sr.ram_code || case when sr.ram_code = 9 then 'xs' end
|| ' ' || sc.cores || ' core CPU (' || sc.cores * 2 || ' threads ' || sr.chipset_speed || ')' as cpu_type
, 'Memory '  || sr.gb || ' GB (' || sr.ram_type || ' ' || sr.ram_speed || ')' as memory_type
, 'Storage ' || sh.tb || ' Terabytes ' as storage_type
, sc.cores
, sc.cores * 2 as threads
, sr.chipset_speed
, sr.ram_type
, sr.gb
, sh.tb
, case when sh.tb < 1 then (sh.tb * 1000) || ' Gb' else sh.tb || ' Tb' end || ' Storage' as storage_description
, ((sc.cores * 50) + (sh.tb * 200) + (trunc(sh.tb/4)*200) + (sr.gb * 20)  + (trunc(sr.gb/100)*1000)) * ff.price_modifier * sr.ram_modifier as base_price
, dense_rank() over (partition by t.product_type_id order by (sc.cores * sh.tb * sr.gb * sr.ram_modifier)) as power_rating
from 
sc#product_types t
join sc#product_categories c on t.product_category_id = c.product_category_id
join form_factors ff on t.product_type_name = ff.product_type_name
cross join system_ram sr cross join system_hdd sh cross join system_cores sc
where c.product_category_name = 'Computers' and t.product_type_name in ('Desktops','Notebooks','Servers')
and (cores >= gb/8 and gb >= cores * 2)
and ((cores between 1 and 7 and tb <= 1) or (cores between 8 and 16 and tb between 1 and 8) or (cores > 16 and tb > 4))
and (
(t.product_type_name = 'Notebooks' and cores <= 24 and tb <= 8)
or (t.product_type_name = 'Desktops' and cores between 4 and 32 and tb < 20)
or (t.product_type_name = 'Servers' and cores >= 8  and tb >= 4 and gb >= 32)
)
)
select s.product_code
, 'Class ' || ntile(5) over (partition by s.product_type_id order by power_rating) || ' ' || s.ff_description 
|| ' ' || s.cores || ' Core CPU ' || s.gb || ' Gb RAM ' || s.ram_type || ' ' || case when s.tb < 1 then (s.tb * 1000) || ' Gb' else s.tb || ' Tb' end || ' Storage' as product_name
, s.ff_description || ' with ' || s.cpu_type || ' ' || s.memory_type || ' ' || s.storage_description as product_description, s.product_type_id, round(s.base_price,-2) as msrp_price
from base_systems s order by s.product_type_name, s.power_rating, s.base_price
;


commit;