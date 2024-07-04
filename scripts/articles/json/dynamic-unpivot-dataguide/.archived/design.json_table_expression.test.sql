prompt query.test.json_table_expression.sql

--Test the resulting sql for json_table syntax


select j.*
from 
    json_table(dynamic_json.get_test_json('simple'), '$[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name"   varchar2(4000) path '$.name'
            , "side"   varchar2(4000) path '$.side'
            , "color"  varchar2(4000) path '$.color'
            , "width"  varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j
/

select j.*
from 
    json_table(dynamic_json.get_test_json('nested'), '$.my_shapes[*]' 
        columns (
            "id#ordinality" for ordinality
            , "name"   varchar2(4000) path '$.name'
            , "side"   varchar2(4000) path '$.side'
            , "color"  varchar2(4000) path '$.color'
            , "width"  varchar2(4000) path '$.width'
            , "height" varchar2(4000) path '$.height'
            , "length" varchar2(4000) path '$.length'
            , "radius" varchar2(4000) path '$.radius'
        )
    ) j
/