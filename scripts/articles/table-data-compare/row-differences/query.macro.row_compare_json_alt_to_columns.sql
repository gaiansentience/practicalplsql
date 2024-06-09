column row_source format a10
column code format a5
column name format a19
column description format a25
column style format a12
column msrp format a4
set null '<<null>>'
set pagesize 20

--compare row differences with json and full outer join using macro with multiple id columns
select * 
from row_compare_json_alt_to_columns(products_source, products_target, columns(product_id, code))
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