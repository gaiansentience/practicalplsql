column jdg format a4000

set long 5000
set pagesize 200

--aggregate the json rows and add them as an array attribute to a single json object
--json_dataguide shows the keys used in these json objects
with json_base as (
    select 
        json_object(
            'source_rows' value json_arrayagg(
                json_object(*)
            returning clob) 
        returning clob) as jdoc 
    from products_source
)
select json_dataguide(jdoc)as jdg
from json_base
/

/*


JDG                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
[
    {"o:path":"$","type":"object","o:length":2048},
    {"o:path":"$.source_rows","type":"array","o:length":2048},
    {"o:path":"$.source_rows.CODE","type":"string","o:length":8},
    {"o:path":"$.source_rows.MSRP","type":"number","o:length":2},
    {"o:path":"$.source_rows.NAME","type":"string","o:length":32},
    {"o:path":"$.source_rows.STYLE","type":"string","o:length":8},
    {"o:path":"$.source_rows.PRODUCT_ID","type":"number","o:length":1},
    {"o:path":"$.source_rows.DESCRIPTION","type":"string","o:length":32}
]

*/
