column row_source format a10
column code format a10
column key_column format a20
column key_value format a50
set null (null)
set long 200
set pagesize 50

--make all columns to be unpivoted the same datatype 
--unpivot compare columns
--use compare row differences of unpivoted columns and show column differences
with coerce_datatypes_source as (
    select 
        product_id, code, 
        name, description, style,     
        to_char(msrp) as msrp 
    from products_source
), coerce_datatypes_target as (
    select 
        product_id, code, 
        name, description, style,     
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
        unpivot include nulls (
            column#value for column#name in (name, description, style, msrp)
        )    
), compare_rows as (
    select 
        coalesce(s.row_source, t.row_source) as row_source
        , coalesce(s.product_id, t.product_id) as product_id
        , coalesce(s.code, t.code) as code
        , coalesce(s.jdoc, t.jdoc) as jdoc
    from   
        (
            select 
                'source' as row_source
                , product_id
                , code
                , json_object(* returning json) as jdoc 
            from unpivot_source    
        ) s
        full outer join 
        (
            select 
                'target' as row_source
                , product_id
                , code
                , json_object(* returning json) as jdoc 
            from unpivot_target    
        ) t 
            on s.product_id = t.product_id
            and s.code = t.code
            and json_equal(s.jdoc, t.jdoc)
    where s.product_id is null or t.product_id is null    
)
select 
    row_source, product_id, code, 
    j.column#name,
    j.column#value
from 
compare_rows c,
json_table(c.jdoc, '$' 
columns(column#name path '$.COLUMN#NAME.string()', column#value path '$.COLUMN#VALUE.string()')
) j
order by product_id, column#name, row_source
/


/*



ROW_SOURCE CODE       KEY_COLUMN           KEY_VALUE                                         
---------- ---------- -------------------- --------------------------------------------------
source     P-ES       DESCRIPTION          Mt. Everest Summit                                
target     P-ES       DESCRIPTION          Mount Everest Summit                              
source     P-EB       DESCRIPTION          Mt. Everest Basecamp                              
target     P-EB       DESCRIPTION          Mount Everest Basecamp                            
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