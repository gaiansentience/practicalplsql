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

grant create role to practicalplsql with admin option;

grant alter system to practicalplsql;
