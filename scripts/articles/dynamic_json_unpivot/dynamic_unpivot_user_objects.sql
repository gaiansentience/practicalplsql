with base as (
select o.* from all_objects o
fetch first 10000 rows only
), json_base as (
select
    json_arrayagg(
    json_object(b.* absent on null returning clob)
    returning clob) as jdoc
from base b
)
select r.*
from
json_base b, dynamic_json_table.unpivot_json(b.jdoc,'OBJECT_ID') r
/

