column row_source_t format a12
column row_source_s format a12
column code format a5
column name format a19
column description format a25
column style format a12
column msrp format a4
set null '<<null>>'
set pagesize 20


--compare row differences with natural full outer join
--does not support clobs
--equality join is not null aware
--identical rows with a null column will show as differences
select *
from   
    (
        select 'source' as row_source_s, s.*
        from products_source s   
    ) s
    natural full outer join (
        select 'target' as row_source_t, t.*
        from products_target t   
    ) t
where row_source_s is null or row_source_t is null
order by product_id
/

/*

Row 7 is included by mistake because of the null in the style column.
With this method nulls in a column for both row sources will result in false differences.

PRODUCT_ID CODE  NAME                DESCRIPTION               STYLE        MSRP ROW_SOURCE_S ROW_SOURCE_T
---------- ----- ------------------- ------------------------- ------------ ---- ------------ ------------
         1 P-ES  Everest Summit      Mt. Everest Summit        18x20          30 source       <<null>>    
         1 P-ES  Everest Summit      Mount Everest Summit      18x20          30 <<null>>     target      
         2 P-EB  Everest Basecamp    Mount Everest Basecamp    18x20          30 <<null>>     target      
         2 P-EB  Everest Basecamp    Mt. Everest Basecamp      18x20          30 source       <<null>>    
         3 P-FD  Fujiyama Dawn       Mount Fuji at dawn        11x17          20 source       <<null>>    
         3 P-FD  Fuji Dawn           Mount Fuji at dawn        11x17          19 <<null>>     target      
         4 P-FS  Fuji Sunset         Mount Fuji at sunset      11x17          20 <<null>>     target      
         4 P-FS  Fujiyama Sunset     Mount Fuji at sunset      11x17          20 source       <<null>>    
         6 PC-ES Everest Postcards   Mount Everest postcards   Monochrome      9 <<null>>     target      
         6 PC-ES Everest Postcards   Mt. Everest postcards     5x7             9 source       <<null>>    
         7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9 <<null>>     target      
         7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9 source       <<null>>    
         8 PC-K2 K2 Postcards        K2 postcards              <<null>>        9 <<null>>     target      
         8 PC-K2 K2 Postcards        K2 postcards              Color           9 source       <<null>>    
         9 PC-S  Shasta Postcards    Mount Shasta postcards    5x7             9 source       <<null>>    

15 rows selected. 


*/