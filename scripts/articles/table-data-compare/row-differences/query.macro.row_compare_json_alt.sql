column row_source format a10
column code format a10
column jdoc format a130
set long 200
set pagesize 20

--compare row differences with json and full outer join using macro with multiple id columns
select * 
from row_compare_json_alt(products_source, products_target, columns(product_id, code))
/

/*

ROW_SOURCE PRODUCT_ID CODE       JDOC                                                                                                                              
---------- ---------- ---------- ----------------------------------------------------------------------------------------------------------------------------------
source              1 P-ES       {"PRODUCT_ID":1,"CODE":"P-ES","NAME":"Everest Summit","DESCRIPTION":"Mt. Everest Summit","STYLE":"18x20","MSRP":30}               
target              1 P-ES       {"PRODUCT_ID":1,"CODE":"P-ES","NAME":"Everest Summit","DESCRIPTION":"Mount Everest Summit","STYLE":"18x20","MSRP":30}             
source              2 P-EB       {"PRODUCT_ID":2,"CODE":"P-EB","NAME":"Everest Basecamp","DESCRIPTION":"Mt. Everest Basecamp","STYLE":"18x20","MSRP":30}           
target              2 P-EB       {"PRODUCT_ID":2,"CODE":"P-EB","NAME":"Everest Basecamp","DESCRIPTION":"Mount Everest Basecamp","STYLE":"18x20","MSRP":30}         
source              3 P-FD       {"PRODUCT_ID":3,"CODE":"P-FD","NAME":"Fujiyama Dawn","DESCRIPTION":"Mount Fuji at dawn","STYLE":"11x17","MSRP":20}                
target              3 P-FD       {"PRODUCT_ID":3,"CODE":"P-FD","NAME":"Fuji Dawn","DESCRIPTION":"Mount Fuji at dawn","STYLE":"11x17","MSRP":19}                    
source              4 P-FS       {"PRODUCT_ID":4,"CODE":"P-FS","NAME":"Fujiyama Sunset","DESCRIPTION":"Mount Fuji at sunset","STYLE":"11x17","MSRP":20}            
target              4 P-FS       {"PRODUCT_ID":4,"CODE":"P-FS","NAME":"Fuji Sunset","DESCRIPTION":"Mount Fuji at sunset","STYLE":"11x17","MSRP":20}                
source              6 PC-ES      {"PRODUCT_ID":6,"CODE":"PC-ES","NAME":"Everest Postcards","DESCRIPTION":"Mt. Everest postcards","STYLE":"5x7","MSRP":9}           
target              6 PC-ES      {"PRODUCT_ID":6,"CODE":"PC-ES","NAME":"Everest Postcards","DESCRIPTION":"Mount Everest postcards","STYLE":"Monochrome","MSRP":9}  
source              8 PC-K2      {"PRODUCT_ID":8,"CODE":"PC-K2","NAME":"K2 Postcards","DESCRIPTION":"K2 postcards","STYLE":"Color","MSRP":9}                       
target              8 PC-K2      {"PRODUCT_ID":8,"CODE":"PC-K2","NAME":"K2 Postcards","DESCRIPTION":"K2 postcards","STYLE":null,"MSRP":9}                          
source              9 PC-S       {"PRODUCT_ID":9,"CODE":"PC-S","NAME":"Shasta Postcards","DESCRIPTION":"Mount Shasta postcards","STYLE":"5x7","MSRP":9}            

13 rows selected. 

*/