create or replace view location_info as
select 
    id as location_id
    , code as location_code
    , name as location_name
    , address
    , city
from locations;
/