column row_source format a10
column code format a10
column column#name format a20
column column#value format a50
set null (null)
set long 200
set pagesize 50


--make all columns to be unpivoted the same datatype 
--unpivot compare columns
--use macro to compare row differences of unpivoted columns and show column differences
with coerce_datatypes_source as (
    select 
        product_id, code, name, description, style,     
        to_char(msrp) as msrp 
    from products_source
), coerce_datatypes_target as (
    select 
        product_id, code, name, description, style,     
        to_char(msrp) as msrp 
    from products_target
), unpivot_source as (
    select product_id, code, column#name, column#value
    from 
        coerce_datatypes_source
        unpivot include nulls (
            column#value for column#name in (name, description, style, msrp)
        )    
), unpivot_target as (
    select product_id, code, column#name, column#value
    from 
        coerce_datatypes_target
        unpivot include nulls(
            column#value for column#name in (name, description, style, msrp)
        )    
)
select 
    b.row_source, b.product_id, b.code, j.column#name, j.column#value
from 
    (
    select row_source, product_id, code, jdoc
    from row_compare(unpivot_source, unpivot_target, columns(product_id, code))
    ) b,
    json_table(b.jdoc, '$'
        columns(
            column#name varchar2(4000) path '$.COLUMN#NAME',
            column#value varchar2(4000) path '$.COLUMN#VALUE'
        )
    ) j
order by b.code, j.column#name, b.row_source
/


/*

ROW_SOURCE CODE       column#name           column#value                                         
---------- ---------- -------------------- --------------------------------------------------
source     P-EB       DESCRIPTION          Mt. Everest Basecamp                              
target     P-EB       DESCRIPTION          Mount Everest Basecamp                            
source     P-ES       DESCRIPTION          Mt. Everest Summit                                
target     P-ES       DESCRIPTION          Mount Everest Summit                              
source     P-FD       MSRP                 20                                                
target     P-FD       MSRP                 19                                                
source     P-FD       NAME                 Fujiyama Dawn                                     
target     P-FD       NAME                 Fuji Dawn                                         
source     P-FS       NAME                 Fujiyama Sunset                                   
target     P-FS       NAME                 Fuji Sunset                                       
source     PC-ES      DESCRIPTION          Mt. Everest postcards                             
target     PC-ES      DESCRIPTION          Mount Everest postcards                           
source     PC-ES      STYLE                5x7                                               
target     PC-ES      STYLE                Monochrome                                        
source     PC-K2      STYLE                Color                                             
target     PC-K2      STYLE                (null)                                            
source     PC-S       DESCRIPTION          Mount Shasta postcards                            
source     PC-S       MSRP                 9                                                 
source     PC-S       NAME                 Shasta Postcards                                  
source     PC-S       STYLE                5x7                                               

20 rows selected. 

*/