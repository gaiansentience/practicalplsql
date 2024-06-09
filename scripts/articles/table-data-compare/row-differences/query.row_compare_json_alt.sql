column row_source format a10
column jdoc format a130
set long 200
set pagesize 20


--compare row differences with json and full outer join
--join can use multiple columns to improve performance
select 
    coalesce(s.row_source, t.row_source) as row_source, 
--    coalesce(s.product_id, t.product_id) as product_id,
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , product_id
            , code
            , json_object(* returning clob) as jdoc 
        from products_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , product_id
            , code
            , json_object(* returning clob) as jdoc 
        from products_target    
    ) t
        on s.product_id = t.product_id
        and s.code = t.code
        and json_equal(s.jdoc, t.jdoc)
where s.product_id is null or t.product_id is null
order by coalesce(s.product_id, t.product_id), row_source
/

/*

ROW_SOURCE JDOC                                                                                                                              
---------- ----------------------------------------------------------------------------------------------------------------------------------
source     {"PRODUCT_ID":1,"CODE":"P-ES","NAME":"Everest Summit","DESCRIPTION":"Mt. Everest Summit","STYLE":"18x20","MSRP":30}               
target     {"PRODUCT_ID":1,"CODE":"P-ES","NAME":"Everest Summit","DESCRIPTION":"Mount Everest Summit","STYLE":"18x20","MSRP":30}             
source     {"PRODUCT_ID":2,"CODE":"P-EB","NAME":"Everest Basecamp","DESCRIPTION":"Mt. Everest Basecamp","STYLE":"18x20","MSRP":30}           
target     {"PRODUCT_ID":2,"CODE":"P-EB","NAME":"Everest Basecamp","DESCRIPTION":"Mount Everest Basecamp","STYLE":"18x20","MSRP":30}         
source     {"PRODUCT_ID":3,"CODE":"P-FD","NAME":"Fujiyama Dawn","DESCRIPTION":"Mount Fuji at dawn","STYLE":"11x17","MSRP":20}                
target     {"PRODUCT_ID":3,"CODE":"P-FD","NAME":"Fuji Dawn","DESCRIPTION":"Mount Fuji at dawn","STYLE":"11x17","MSRP":19}                    
source     {"PRODUCT_ID":4,"CODE":"P-FS","NAME":"Fujiyama Sunset","DESCRIPTION":"Mount Fuji at sunset","STYLE":"11x17","MSRP":20}            
target     {"PRODUCT_ID":4,"CODE":"P-FS","NAME":"Fuji Sunset","DESCRIPTION":"Mount Fuji at sunset","STYLE":"11x17","MSRP":20}                
source     {"PRODUCT_ID":6,"CODE":"PC-ES","NAME":"Everest Postcards","DESCRIPTION":"Mt. Everest postcards","STYLE":"5x7","MSRP":9}           
target     {"PRODUCT_ID":6,"CODE":"PC-ES","NAME":"Everest Postcards","DESCRIPTION":"Mount Everest postcards","STYLE":"Monochrome","MSRP":9}  
source     {"PRODUCT_ID":8,"CODE":"PC-K2","NAME":"K2 Postcards","DESCRIPTION":"K2 postcards","STYLE":"Color","MSRP":9}                       
target     {"PRODUCT_ID":8,"CODE":"PC-K2","NAME":"K2 Postcards","DESCRIPTION":"K2 postcards","STYLE":null,"MSRP":9}                          
source     {"PRODUCT_ID":9,"CODE":"PC-S","NAME":"Shasta Postcards","DESCRIPTION":"Mount Shasta postcards","STYLE":"5x7","MSRP":9}            

13 rows selected. 

*/