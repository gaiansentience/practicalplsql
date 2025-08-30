--6.0-test-data-view.sql
create or replace view test_data as
with base(n, i) as (
    values 
        (8.5, 5), (13, 5), (0.42, 0.25), (1.08, 0.25)
)
select n, i from base
union all
select -n, i from base
/
