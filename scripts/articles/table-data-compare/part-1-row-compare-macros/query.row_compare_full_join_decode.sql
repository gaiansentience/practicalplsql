set feedback off
column row_source format a10
column code format a5
column name format a19
column description format a25
column style format a12
column msrp format a4
set null '<<null>>'
set pagesize 20


--compare row differences with full outer join
--use decode for a null aware join on non id fields
--identical rows with a null field will not show as differences
select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.name, t.name) as name
    , coalesce(s.description, t.description) as description
    , coalesce(s.style, t.style) as style
    , coalesce(s.msrp, t.msrp) as msrp
from   
    (
        select 'source' as row_source, s.* from products_source s   
    ) s
    full outer join (
        select 'target' as row_source, t.* from products_target t
    ) t
        on s.product_id = t.product_id
        and decode(s.code, t.code, 1, 0) = 1
        and decode(s.name, t.name, 1, 0) = 1
        and decode(s.description, t.description, 1, 0) = 1
        and decode(s.style, t.style, 1, 0) = 1
        and decode(s.msrp, t.msrp, 1, 0) = 1
where s.product_id is null or t.product_id is null
order by product_id, row_source
/
