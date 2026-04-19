alter session set container=FREEPDB1;

create role system_monitor;

grant select on v_$session to system_monitor;
grant select on v_$sesstat to system_monitor;
grant select on v_statname to system_monitor;
grant select on v_$mystat to system_monitor;
grant select on v_$sql to system_monitor;
grant select on v_$sqlarea to system_monitor;
grant select on v_$sql_plan to system_montior;
grant select on v_$sql_plan_statistics_all to system_monitor;

grant select on v_$diag_info to system_monitor;
grant select on v_$diag_trace_file to system_monitor;
grant select on v_$diag_trace_file_contents to system_monitor;

--?? grant system monitor to db_developer_role


grant system_monitor to practicalplsql;
