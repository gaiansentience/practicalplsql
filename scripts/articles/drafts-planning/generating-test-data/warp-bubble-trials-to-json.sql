alter session set time_zone = dbtimezone;

set pagesize 0
set feedback off
set serveroutput on;

spool ./warp-bubble-trials-from-json.sql

begin

    dbms_output.put_line(q'!
    with jbase as (
    select
        to_clob('[')!');
    
end;
/

with base as (
select 
    id, fuel
    , to_char(start_run,'yyyy-mm-dd') as start_dt, to_char(start_run,'hh24:mi:ss.ff9') as start_tm
    , datediff(nanosecond, start_run, start_bubble) as warmup_ns
    , datediff(nanosecond, start_bubble, end_bubble) as bubble_ns
    , datediff(nanosecond, end_bubble, end_run) as cooldown_ns
from qz_warp_bubble_trials
)
select ' || to_clob(q' || '''!' || json_object(b.* returning varchar2) || '!'' || '','')' as jrow 
from base b
/

begin

    dbms_output.put_line(q'!
        || to_clob(']') as jdoc
    ), rbase as (
    select 
        jt.id, jt.fuel
        , to_timestamp(jt.start_dt || ' ' || jt.start_tm,'yyyy-mm-dd hh24:mi:ss.ff9') as start_ts
        , jt.warmup_ns, jt.bubble_ns, jt.cooldown_ns
    from jbase j,
        json_table(j.jdoc, '$[*]' columns(
            id          path '$.ID.number()',
            fuel        path '$.FUEL.string()',
            start_dt    path '$.START_DT.string()',
            start_tm    path '$.START_TM.string()',
            warmup_ns   path '$.WARMUP_NS.number()',
            bubble_ns   path '$.BUBBLE_NS.number()',
            cooldown_ns path '$.COOLDOWN_NS.number()'
        )) jt
    )
    select r.id, r.fuel
        , r.start_ts as start_run
        , dateadd(nanosecond, r.warmup_ns, r.start_ts) as start_bubble
        , dateadd(nanosecond, r.warmup_ns + r.bubble_ns, r.start_ts) as end_bubble
        , dateadd(nanosecond, r.warmup_ns + r.bubble_ns + r.cooldown_ns, r.start_ts) as end_run
    from rbase r
    order by r.id
    /
    !');
    
end;
/


spool off