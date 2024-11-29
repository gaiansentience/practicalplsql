column row_source format a10
column product_id format 9
column code format a6
column column_name format a12
column column_value format a30
set null (null)
set pagesize 50

prompt 1.2-query-unpivot-for-column-differences.sql
prompt unpivot to decompose rows and use full outer join comparison with json_equal

with unpivot_source as (
    select product_id, code, column_name, column_value
    from 
        products_source
        unpivot include nulls (
            column_value for column_name in (
                name, description, style)
        )    
), unpivot_target as (
    select product_id, code, column_name, column_value
    from 
        products_target
        unpivot include nulls (
            column_value for column_name in (
                name, description, style)
        )    
)
select 
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.column_name, t.column_name) as column_name
    , coalesce(s.column_value, t.column_value) as column_value
from
    (
        select 'source' as row_source, json_object(b.*) as jdoc, b.* from unpivot_source b
    ) s
    full outer join (
        select 'target' as row_source, json_object(b.*) as jdoc, b.* from unpivot_target b
    ) t
        on s.product_id = t.product_id 
        and s.code = t.code
        and s.column_name = t.column_name
        and json_equal(s.jdoc, t.jdoc)
where
    s.product_id is null or t.product_id is null
order by product_id, column_name, row_source
/

/*

1.2-query-unpivot-for-column-differences.sql
unpivot to decompose rows and use full outer join comparison with json_equal

ROW_SOURCE PRODUCT_ID CODE   COLUMN_NAME  COLUMN_VALUE                  
---------- ---------- ------ ------------ ------------------------------
source              1 P-ES   DESCRIPTION  Mt. Everest Summit            
target              1 P-ES   DESCRIPTION  Mount Everest Summit          
source              2 P-EB   DESCRIPTION  Mt. Everest Basecamp          
target              2 P-EB   DESCRIPTION  Mount Everest Basecamp        
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
source              9 PC-S   DESCRIPTION  Mount Shasta postcards        
source              9 PC-S   NAME         Shasta Postcards              
source              9 PC-S   STYLE        5x7                           

17 rows selected. 

*/