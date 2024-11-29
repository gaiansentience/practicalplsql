column column_name format a15
column column_type format a15
column column_path format a15

set long 5000
set pagesize 200

--row difference macro converts rows to json to use json_equal for the full outer join
--json_dataguide shows the keys used in these json objects
--use json_table to convert this dataguide to relational rowsource
with json_base as (
    select json_object(*) as jdoc from products_source
    union all
    select json_object(*) as jdoc from products_target
), dataguide_base as (
    select json_dataguide(jdoc)as jdg
    from json_base
), columns_base as (
select
    replace(c.column_path, '$.') as column_name
    , c.column_type
    , c.column_path
from 
    dataguide_base b,
    json_table(b.jdg, '$[*]' 
        columns(
            column_path  path '$."o:path"'
            , column_type  path '$.type'
            )
    ) c
)
select column_name, column_type, column_path
from columns_base
where column_type <> 'object'
/

/*

COLUMN_NAME     COLUMN_TYPE     COLUMN_PATH    
--------------- --------------- ---------------
CODE            string          $.CODE         
MSRP            number          $.MSRP         
NAME            string          $.NAME         
STYLE           string          $.STYLE        
PRODUCT_ID      number          $.PRODUCT_ID   
DESCRIPTION     string          $.DESCRIPTION  

6 rows selected. 

*/
