create or replace view job_info as
select
    id as job_id
    , code as job_code
    , name as job_name
from jobs;
/
