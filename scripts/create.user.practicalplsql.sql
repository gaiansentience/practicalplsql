--run as sys
create user practicalplsql identified by oracle;

grant create session to practicalplsql;
grant resource to practicalplsql;

alter user practicalplsql
default tablespace users
 quota unlimited on users
container = current;

grant create synonym to practicalplsql;
grant create public synonym to practicalplsql;
grant create table to practicalplsql;
grant create sequence to practicalplsql;
grant create view to practicalplsql;
grant create materialized view to practicalplsql;
grant create procedure to practicalplsql;
grant create type to practicalplsql;
--23c only
grant create domain to practicalplsql;
grant db_developer_role to practicalplsql;

grant create role to practicalplsql with admin option;
grant create any context to practicalplsql with admin option;

grant alter system to practicalplsql;

--grants for autotrace
grant select_catalog_role to practicalplsql;
grant select any dictionary to practicalplsql;
grant select on v_$sql to practicalplsql;
grant select on v_$sql_plan_statistics_all to practicalplsql;
grant select on v_$session to practicalplsql;
grant select on v_$sesstat to practicalplsql;
grant select on v_$statname to practicalplsql;

grant select on v_$sqlarea to practicalplsql;
grant select on v_$open_cursor to practicalplsql;
grant select on v_$temporary_lobs to practicalplsql;
grant select on v_$sql_plan to practicalplsql;

--grants for tracing
grant execute on dbms_monitor to practicalplsql;
grant advisor to practicalplsql;
grant select on v_$diag_trace_file to practicalplsql;
grant select on v_$diag_trace_file_contents to practicalplsql;

