column column_name format a15
column column_type format a15
column column_path format a15
column aggregate_column_path format a30

set long 5000
set pagesize 200

--aggregate the json rows and add them as an array attribute to a single json object
--json_dataguide shows the keys used in these json objects
--use json_table to convert this dataguide to relational rowsource
--compensate for the additional path value and the array element
with json_base as (
    select 
        json_object(
            'source_rows' value json_arrayagg(
                json_object(*)
            returning clob) 
        returning clob) as jdoc 
    from products_source
), dataguide_base as (
    select json_dataguide(jdoc)as jdg
    from json_base
), columns_base as (
select
    replace(c.column_path, '$.source_rows.') as column_name
    , c.column_type
    , replace(c.column_path, 'source_rows.') as column_path
    , c.column_path as aggregate_column_path
from 
    dataguide_base b,
    json_table(b.jdg, '$[*]' 
        columns(
            column_path  path '$."o:path"'
            , column_type  path '$.type'
            )
    ) c
)
select column_name, column_type, column_path, aggregate_column_path
from columns_base
where column_type not in ( 'object', 'array' )
/

/*

COLUMN_NAME     COLUMN_TYPE     COLUMN_PATH     AGGREGATE_COLUMN_PATH         
--------------- --------------- --------------- ------------------------------
CODE            string          $.CODE          $.source_rows.CODE            
MSRP            number          $.MSRP          $.source_rows.MSRP            
NAME            string          $.NAME          $.source_rows.NAME            
STYLE           string          $.STYLE         $.source_rows.STYLE           
PRODUCT_ID      number          $.PRODUCT_ID    $.source_rows.PRODUCT_ID      
DESCRIPTION     string          $.DESCRIPTION   $.source_rows.DESCRIPTION     

6 rows selected. 

*/
