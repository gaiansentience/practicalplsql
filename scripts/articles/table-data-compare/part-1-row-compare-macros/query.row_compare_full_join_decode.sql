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

/*

ROW_SOURCE PRODUCT_ID CODE  NAME                DESCRIPTION               STYLE        MSRP
---------- ---------- ----- ------------------- ------------------------- ------------ ----
source              1 P-ES  Everest Summit      Mt. Everest Summit        18x20          30
target              1 P-ES  Everest Summit      Mount Everest Summit      18x20          30
source              2 P-EB  Everest Basecamp    Mt. Everest Basecamp      18x20          30
target              2 P-EB  Everest Basecamp    Mount Everest Basecamp    18x20          30
source              3 P-FD  Fujiyama Dawn       Mount Fuji at dawn        11x17          20
target              3 P-FD  Fuji Dawn           Mount Fuji at dawn        11x17          19
source              4 P-FS  Fujiyama Sunset     Mount Fuji at sunset      11x17          20
target              4 P-FS  Fuji Sunset         Mount Fuji at sunset      11x17          20
source              6 PC-ES Everest Postcards   Mt. Everest postcards     5x7             9
target              6 PC-ES Everest Postcards   Mount Everest postcards   Monochrome      9
source              8 PC-K2 K2 Postcards        K2 postcards              Color           9
target              8 PC-K2 K2 Postcards        K2 postcards              <<null>>        9
source              9 PC-S  Shasta Postcards    Mount Shasta postcards    5x7             9

13 rows selected. 


*/