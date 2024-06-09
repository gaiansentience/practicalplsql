column row_source format a10
column code format a10
column key_column format a20
column key_value format a50
set null (null)
set long 200
set pagesize 50

--ideally, we want to use json_table and unpivot on the results of the comparison macro to get the row differences
--then we could use the comparison macro again to compare the column differences
--because macros cant be used in CTE expressions, we have to create a workaround
--if we write the comparison sql instead of using the macro, we can use multiple cte expressions to solve this
--The CTE Expressions for row_json_source, row_json_target and compare_rows are the same as the sql created by the row comparison macro
with row_json_source as (
    select 
        'source' as row_source, code
        , json_object(* returning clob) as jdoc 
    from products_source    
), row_json_target as (
    select 
        'target' as row_source, code
        , json_object(* returning clob) as jdoc 
    from products_target    
), compare_rows_json as (
    select 
        coalesce(s.row_source, t.row_source) as row_source, 
        coalesce(s.code, t.code) as code,
        coalesce(s.jdoc, t.jdoc) as jdoc
    from  
        row_json_source s
        full outer join row_json_target t
            on s.code = t.code
            and json_equal(s.jdoc, t.jdoc)
    where s.code is null or t.code is null
), compare_rows_relational as (
    select 
        b.row_source, b.code, 
        j.name, j.description, j.style, j.msrp
    from 
        compare_rows_json b,
        json_table(b.jdoc, '$' 
            columns (
                name varchar2(4000) path '$.NAME',
                description varchar2(4000) path '$.DESCRIPTION',
                style varchar2(4000) path '$.STYLE',
                msrp varchar2(4000) path '$.MSRP'
            )
        ) j
), compare_cols_base as (
    select row_source, code, key_column, key_value
    from 
        compare_rows_relational
        unpivot include nulls (
            key_value for key_column in (name, description, style, msrp)    
        )
), compare_cols_source as (
    select code, key_column, key_value
    from compare_cols_base where row_source = 'source'
), compare_cols_target as (
    select code, key_column, key_value
    from compare_cols_base where row_source = 'target'
)
select
    b.row_source, b.code,
    j.key_column, j.key_value
from 
    (
    select row_source, code, jdoc
    from row_compare_json_alt(compare_cols_source, compare_cols_target, columns(code))
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