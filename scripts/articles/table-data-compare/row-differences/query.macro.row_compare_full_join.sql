column row_source format a10
column code format a5
column name format a19
column description format a25
column style format a12
column msrp format a4
set null '<<null>>'
set pagesize 20

--compare row differences with full outer join using macro
--does not handle identical rows with null columns
--does not handle clob columns
select *
from row_compare_full_join(products_source, products_target, columns(product_id))
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
source              7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9
target              7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9
source              8 PC-K2 K2 Postcards        K2 postcards              Color           9
target              8 PC-K2 K2 Postcards        K2 postcards              <<null>>        9
source              9 PC-S  Shasta Postcards    Mount Shasta postcards    5x7             9

15 rows selected. 

select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID"
    , coalesce(s."CODE", t."CODE") as "CODE"
    , coalesce(s."NAME", t."NAME") as "NAME"
    , coalesce(s."DESCRIPTION", t."DESCRIPTION") as "DESCRIPTION"
    , coalesce(s."STYLE", t."STYLE") as "STYLE"
    , coalesce(s."MSRP", t."MSRP") as "MSRP"
from   
    (
        select 'source' as row_source, src.* from p_source src   
    ) s
    full outer join (
        select 'target' as row_source, tgt.* from p_target tgt
    ) t
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and s."CODE" = t."CODE"
        and s."NAME" = t."NAME"
        and s."DESCRIPTION" = t."DESCRIPTION"
        and s."STYLE" = t."STYLE"
        and s."MSRP" = t."MSRP"
where 
    s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by "PRODUCT_ID", row_source

*/