prompt query.test.unpivot_query.sql

--Test the resulting sql for unpivot syntax    

with json_to_relational as (

select j.*
from 
    json_table(dynamic_json.get_test_json('simple'), '$[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

)
select "id#ordinality", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
            "name"
            , "side"
            , "color"
            , "width"
            , "height"
            , "length"
            , "radius"
            )
    ) 
order by "id#ordinality", "column#key"
/

with json_to_relational as (

select j.*
from 
    json_table(dynamic_json.get_test_json('nested'), '$.my_shapes[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name" varchar2(4000) path '$.name'
            , "side" varchar2(4000) path '$.side'
            , "color" varchar2(4000) path '$.color'
            , "width" varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j

)
select "id#ordinality", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
            "name"
            , "side"
            , "color"
            , "width"
            , "height"
            , "length"
            , "radius"
            )
    ) 
order by "id#ordinality", "column#key"
/