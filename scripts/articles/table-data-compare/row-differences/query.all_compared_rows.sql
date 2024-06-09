set feedback off
column code format a5
column name format a19
column description format a25
column style format a12
column msrp format a4
set null '<<null>>'

prompt
prompt select product_id, code, name, description, style, msrp from products_source;
select product_id, code, name, description, style, msrp from products_source;

prompt
prompt select product_id, code, name, description, style, msrp from products_target;

select product_id, code, name, description, style, msrp from products_target;

set feedback on

/*



select product_id, code, name, description, style, msrp from products_source


select product_id, code, name, description, style, msrp from products_source

PRODUCT_ID CODE  NAME                DESCRIPTION               STYLE        MSRP
---------- ----- ------------------- ------------------------- ------------ ----
         1 P-ES  Everest Summit      [Mt.] Everest Summit      18x20          30
         2 P-EB  Everest Basecamp    [Mt.] Everest Basecamp    18x20          30
         3 P-FD  [Fujiyama] Dawn     Mount Fuji at dawn        11x17         [20]
         4 P-FS  [Fujiyama] Sunset   Mount Fuji at sunset      11x17          20
         5 P-K2  K2 Summit           K2 summit                 11x17          20
         6 PC-ES Everest Postcards   [Mt.] Everest postcards   [5x7]           9
         7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9
         8 PC-K2 K2 Postcards        K2 postcards              [Color]         9
[        9 PC-S  Shasta Postcards    Mount Shasta postcards    5x7             9]

select product_id, code, name, description, style, msrp from products_target

PRODUCT_ID CODE  NAME                DESCRIPTION               STYLE        MSRP
---------- ----- ------------------- ------------------------- ------------ ----
         1 P-ES  Everest Summit     [Mount] Everest Summit     18x20          30
         2 P-EB  Everest Basecamp   [Mount] Everest Basecamp   18x20          30
         3 P-FD [Fuji] Dawn          Mount Fuji at dawn        11x17         [19]
         4 P-FS [Fuji] Sunset        Mount Fuji at sunset      11x17          20
         5 P-K2  K2 Summit           K2 summit                 11x17          20
         6 PC-ES Everest Postcards  [Mount] Everest postcards [Monochrome]     9
         7 PC-FJ Fuji Postcards      Mount Fuji postcards      <<null>>        9
         8 PC-K2 K2 Postcards        K2 postcards             [<<null>>]       9

Note: Brackets Added To Highlight Differences
*/