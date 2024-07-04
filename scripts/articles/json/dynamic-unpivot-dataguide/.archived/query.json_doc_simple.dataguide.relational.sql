prompt query.json_doc_simple.dataguide.relational.sql

set long 1000
set pagesize 100
column path format a20
column datatype format a10
column length format 9999

with json_document as (
    select dynamic_json.get_test_json('simple') as jdoc
    from dual
), dataguide as (
    select json_dataguide(b.jdoc) as jdoc_dataguide
    from json_document b
)
select j."path", j."datatype", j."length"
from 
    dataguide g,
    json_table(g.jdoc_dataguide, '$[*]'
        columns(
            "path" path '$."o:path".string()',
            "datatype" path '$.type.string()',
            "length" path '$."o:length".number()'
        )
    ) j
/

/*
path                 datatype   length
-------------------- ---------- ------
$                    array           1
$.name               string         16
$.side               number          2
$.color              string          4
$.width              number          2
$.height             number          2
$.length             number          2
$.radius             number          2
*/