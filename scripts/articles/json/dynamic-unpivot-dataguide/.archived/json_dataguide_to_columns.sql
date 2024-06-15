column column_name format a15
column column_type format a15
column column_path format a15

with json_base as (
    select
        q'~
        [
            {"id":1,"a":"1.a","b":"1.b","c":"1.c"},
            {"id":2,"a":"2.a","b":"2.b"},
            {"id":3,"a":"3.a","b":"3.b","c":"3.c","d":"3.d"},
            {"id":4,"a":"4.a","b":"4.b","c":"4.c","e":"4.e"},
            {"id":5,"a":"5.a",
                "f":{"fA":"4.fA","fB":"4.fB"}
            },
            {"id":6,"a":"6.a","c":"6.c"}
        ]
        ~' as jdoc
    from dual
), dataguide_base as (
    select json_dataguide(b.jdoc) as jdg
    from json_base b
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
/

/*
COLUMN_NAME     COLUMN_TYPE     COLUMN_PATH    
--------------- --------------- ---------------
a               string          $.a            
b               string          $.b            
c               string          $.c            
d               string          $.d            
e               string          $.e            
f               object          $.f            
f.fA            string          $.f.fA         
f.fB            string          $.f.fB         
id              number          $.id           

9 rows selected. 
*/