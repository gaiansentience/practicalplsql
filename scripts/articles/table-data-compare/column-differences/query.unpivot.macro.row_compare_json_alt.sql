column row_source format a10
column code format a10
column key_column format a20
column key_value format a50
set null (null)
set long 200
set pagesize 50


--make all columns to be unpivoted the same datatype 
--unpivot compare columns
--use macro to compare row differences of unpivoted columns and show column differences
with coerce_datatypes_source as (
    select 
        code, name, description, style,     
        to_char(msrp) as msrp 
    from products_source
), coerce_datatypes_target as (
    select 
        code, name, description, style,     
        to_char(msrp) as msrp 
    from products_target
), unpivot_source as (
    select code, key_column, key_value
    from 
        coerce_datatypes_source
        unpivot include nulls (
            key_value for key_column in (name, description, style, msrp)
        )    
), unpivot_target as (
    select code, key_column, key_value
    from 
        coerce_datatypes_target
        unpivot include nulls(
            key_value for key_column in (name, description, style, msrp)
        )    
)
select 
    b.row_source, b.code, j.key_column, j.key_value
from 
    (
    select row_source, code, jdoc
    from row_compare_json_alt(unpivot_source, unpivot_target, columns(code))
    ) b,
    json_table(b.jdoc, '$'
        columns(
            key_column varchar2(4000) path '$.KEY_COLUMN',
            key_value varchar2(4000) path '$.KEY_VALUE'
        )
    ) j
order by b.code, j.key_column, b.row_source
/


/*

ROW_SOURCE CODE       KEY_COLUMN           KEY_VALUE                                         
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