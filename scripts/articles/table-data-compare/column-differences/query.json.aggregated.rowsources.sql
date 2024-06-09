column jdoc format a4000

set long 5000
set pagesize 200

--aggregate the json rows and add them as an array attribute to a single json object
with json_base as (
    select 
        json_object(
            'source_rows' value json_arrayagg(
                json_object(*)
            returning clob) 
        returning clob) as jdoc 
    from products_source
)
select jdoc 
from json_base
/

/*

JDOC 

{"source_rows":
    [
        {"PRODUCT_ID":1,"CODE":"P-ES","NAME":"Everest Summit","DESCRIPTION":"Mt. Everest Summit","STYLE":"18x20","MSRP":30},
        {"PRODUCT_ID":2,"CODE":"P-EB","NAME":"Everest Basecamp","DESCRIPTION":"Mt. Everest Basecamp","STYLE":"18x20","MSRP":30},
        {"PRODUCT_ID":3,"CODE":"P-FD","NAME":"Fujiyama Dawn","DESCRIPTION":"Mount Fuji at dawn","STYLE":"11x17","MSRP":20},
        ....more json objects for rows...
        {"PRODUCT_ID":8,"CODE":"PC-K2","NAME":"K2 Postcards","DESCRIPTION":"K2 postcards","STYLE":"Color","MSRP":9},
        {"PRODUCT_ID":9,"CODE":"PC-S","NAME":"Shasta Postcards","DESCRIPTION":"Mount Shasta postcards","STYLE":"5x7","MSRP":9}
    ]
}

*/
