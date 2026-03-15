alter session set container=FREEPDB1;

create user if not exists practicalplsql identified by oracle;

alter user practicalplsql quota unlimited on users;

grant connect, db_developer_role to practicalplsql;

grant create domain to practicalplsql;

grant create assertion to practicalplsql;

grant create mining model to practicalplsql;
