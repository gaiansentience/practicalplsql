prompt design-3.1-dataguide_columns-query.sql

column column_name format a12
column column_type format a12
column column_path format a12

prompt convert the dataguide to column definitions using json_table in sql

with dataguide as (
    select json_dataguide(dynamic_json#test.test_jdoc('simple')) as jdoc_dataguide
    from dual
), dataguide_relational as (
    select 
        dbms_assert.enquote_name(ltrim(j.dg_path, '$.'), capitalize => false) as column_name,
        --before 23ai we cannot use a boolean in sql
        --'"' || ltrim(j.dg_path, '$.') || '"' as column_name,
        j.column_type,
        j.dg_path as column_path
    from 
        dataguide g,
        json_table(g.jdoc_dataguide, '$[*]'
            columns(
                dg_path path '$."o:path".string()',
                column_type path '$.type.string()'
            )
        ) j
)
select column_name, column_type, column_path
from dataguide_relational
where column_type not in ('object', 'array')
/

prompt adjust column name and relative path for the nested format by removing the array path

with dataguide as (
    select json_dataguide(dynamic_json#test.test_jdoc('nested')) as jdoc_dataguide
    from dual
), dataguide_relational as (
    select 
        dbms_assert.enquote_name(ltrim(replace(j.dg_path, '.my_shapes'), '$.'), capitalize => false) as column_name,
        --before 23ai we cannot use a boolean in sql
        --'"' || ltrim(replace(j.dg_path, '.my_shapes'), '$.') || '"' as column_name,
        j.column_type,
        replace(j.dg_path, '.my_shapes') as column_path
    from 
        dataguide g,
        json_table(g.jdoc_dataguide, '$[*]'
            columns(
                dg_path path '$."o:path".string()',
                column_type path '$.type.string()'
            )
        ) j
)
select column_name, column_type, column_path
from dataguide_relational
where column_type not in ('object', 'array')
/
    
/*
design-3.1-dataguide_columns-query.sql
convert the dataguide to column definitions using json_table in sql

COLUMN_NAME  COLUMN_TYPE  COLUMN_PATH 
------------ ------------ ------------
"name"       string       $.name      
"side"       number       $.side      
"color"      string       $.color     
"width"      number       $.width     
"height"     number       $.height    
"length"     number       $.length    
"radius"     number       $.radius    

7 rows selected. 

adjust column name and relative path for the nested format by removing the array path

COLUMN_NAME  COLUMN_TYPE  COLUMN_PATH 
------------ ------------ ------------
"name"       string       $.name      
"side"       number       $.side      
"color"      string       $.color     
"width"      number       $.width     
"height"     number       $.height    
"length"     number       $.length    
"radius"     number       $.radius    

7 rows selected. 


*/