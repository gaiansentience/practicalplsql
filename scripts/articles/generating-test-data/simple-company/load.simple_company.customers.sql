insert into sc#regions(region_name, region_description) values ('east', 'eastern sales region');
insert into sc#regions(region_name, region_description) values ('west', 'western sales region');
insert into sc#regions(region_name, region_description) values ('north', 'northern sales region');
insert into sc#regions(region_name, region_description) values ('south', 'southern sales region');
insert into sc#regions(region_name, region_description) values ('central', 'central sales region');

insert into sc#customers(customer_name, region_id, is_b2b) 
with base as (select level as n from dual connect by level <= 26
), prefixes as (select lpad(' ',4,chr(b.n + 64))  as prefix from base b
), business_type as (select case n when 1 then 'Inc' when 2 then 'Co' when 3 then 'Supply' when 4 then 'Repair' when 5 then 'Ltd' end as b_type from base b where n <= 5
), business_line as (select case n when 1 then 'Food' when 2 then 'Tool' when 3 then 'Office' when 4 then 'Clothes' when 5 then 'Appliance' when 6 then 'Electronics' end as b_line from base where n <= 6
) select p.prefix || l.b_line || ' ' || t.b_type as customer_name, mod(rownum, 5) + 1 as region_id, 1 as is_b2b
from prefixes p cross join business_type t cross join business_line l;

insert into sc#customers(customer_name, region_id) 
with n_base as (select level as n from dual connect by level <= 25
) ,first_names as (
select 
    case b.n 
        when 1 then 'John' when 2 then 'Joan' when 3 then 'Edward' when 4 then 'Edith' when 5 then 'Sarah' 
        when 6 then 'Stan' when 7 then 'Susan' when 8 then 'Sam' when 9 then 'Carl' when 10 then 'Cynthia'
        when 11 then 'Hillary' when 12 then 'Howard' when 13 then 'Katelyn' when 14 then 'Kimberly' when 15 then 'Arthur'
        when 16 then 'Albert' when 17 then 'Marie' when 18 then 'Nikola' when 19 then 'Ben' when 20 then 'Michael'
        when 21 then 'April' when 22 then 'May' when 23 then 'June' when 24 then 'Alex' when 25 then 'Alexa'
    end as f_name
from n_base b
), last_names as (
select 
    case b.n
        when 1 then 'Green' when 2 then 'Jett' when 3 then 'Bernstein' when 4 then 'Bridges' when 5 then 'Silvers'
        when 6 then 'Rogers' when 7 then 'Connors' when 8 then 'Davis' when 9 then 'Sagan' when 10 then 'Marx'
        when 11 then 'White' when 12 then 'Hughes' when 13 then 'Faraday' when 14 then 'Friedmann' when 15 then 'Ashe'
        when 16 then 'Einstein' when 17 then 'Curie' when 18 then 'Tesla' when 19 then 'Bova' when 20 then 'Burton'
        when 21 then 'Hayward' when 22 then 'Delacroix' when 23 then 'Baker' when 24 then 'Conway' when 25 then 'Hill'
    end as l_name    
from n_base b)
select f.f_name || ' ' || substr(m.f_name,1,1) || '. ' || l.l_name as customer_name, mod(rownum,5) + 1 as region_id
from first_names f cross join first_names m cross join last_names l;

commit;

prompt loaded customer base