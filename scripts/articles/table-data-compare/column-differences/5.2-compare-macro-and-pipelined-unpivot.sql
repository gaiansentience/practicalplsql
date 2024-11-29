column row_source format a10
column product_id format 9
column code format a6
column column#name format a12
column column#value format a30
set null (null)
set pagesize 50

prompt 5.2-compare-macro-and-pipelined-unpivot.sql
prompt macros can also be combined pipelined functions if the pipelined logic could not be converted to a macro
with unpivot_source as (
    select s.product_id, s.code, u.*
    from
        (
            select product_id, code, json_object(*) as jdoc 
            from products_source 
        ) s,
        dynamic_json.unpivot_json_row(s.jdoc) u
), unpivot_target as (
    select s.product_id, s.code, u.*
    from
        (
            select product_id, code, json_object(*) as jdoc 
            from products_target
        ) s,
        dynamic_json.unpivot_json_row(s.jdoc) u
)
select 
    row_source
    , product_id
    , code
    , column#name
    , column#value
from 
    find_row_differences(unpivot_source, unpivot_target, columns(product_id, code,column#name)) 
order by product_id, code, column#name, row_source
/

/*
5.2-compare-macro-and-pipelined-unpivot.sql
macros can also be combined pipelined functions if the pipelined logic could not be converted to a macro

ROW_SOURCE PRODUCT_ID CODE   COLUMN#NAME  COLUMN#VALUE                  
---------- ---------- ------ ------------ ------------------------------
source              1 P-ES   DESCRIPTION  Mt. Everest Summit            
target              1 P-ES   DESCRIPTION  Mount Everest Summit          
source              2 P-EB   DESCRIPTION  Mt. Everest Basecamp          
target              2 P-EB   DESCRIPTION  Mount Everest Basecamp        
source              3 P-FD   MSRP         20                            
target              3 P-FD   MSRP         19                            
source              3 P-FD   NAME         Fujiyama Dawn                 
target              3 P-FD   NAME         Fuji Dawn                     
source              4 P-FS   NAME         Fujiyama Sunset               
target              4 P-FS   NAME         Fuji Sunset                   
source              6 PC-ES  DESCRIPTION  Mt. Everest postcards         
target              6 PC-ES  DESCRIPTION  Mount Everest postcards       
source              6 PC-ES  STYLE        5x7                           
target              6 PC-ES  STYLE        Monochrome                    
source              8 PC-K2  STYLE        Color                         
target              8 PC-K2  STYLE        (null)                        
source              9 PC-S   CODE         PC-S                          
source              9 PC-S   DESCRIPTION  Mount Shasta postcards        
source              9 PC-S   MSRP         9                             
source              9 PC-S   NAME         Shasta Postcards              
source              9 PC-S   PRODUCT_ID   9                             
source              9 PC-S   STYLE        5x7                           

22 rows selected. 


*/