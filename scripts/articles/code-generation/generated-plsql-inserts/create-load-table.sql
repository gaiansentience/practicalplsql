--set pagesize 0;

drop table if exists test_staging purge;
drop table if exists test_target purge;

create table test_staging(
id number primary key,
n_val number,
s_val varchar2(100),
d_val date,
ts_val timestamp,
tstz_val timestamp with time zone
)
/

create table test_target(
id number primary key,
n_val number,
s_val varchar2(100),
d_val date,
ts_val timestamp,
tstz_val timestamp with time zone
)
/

insert into test_staging
by name
select 
    level as id
    , case when mod(level, 7) = 0 then null 
        else to_number(mod(level,10)||mod(level,17)) end as n_val
    , case when mod(level, 5) = 0 then null 
        else lpad(chr(64 + mod(level,26)), dbms_random.value(0,100), chr(64 + mod(level,26))) end as s_val
    , case when mod(level, 4) = 0 then null 
        else sysdate + numtodsinterval(level/3.14, 'day') end as d_val
    , case when mod(level, 3) = 0 then null
        else localtimestamp + numtodsinterval(level/3.14, 'hour') end as ts_val
    , case when mod(level, 2) = 0 then null
        else (current_timestamp + numtodsinterval(power(level,3), 'second')) at time zone 'PST' end as tstz_val
connect by level < 1000
/

commit;

