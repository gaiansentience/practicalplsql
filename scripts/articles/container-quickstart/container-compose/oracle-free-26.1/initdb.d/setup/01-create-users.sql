alter session set container=FREEPDB1;

create user if not exists devgym identified by oracle;

alter user devgym quota unlimited on users;

grant connect, db_developer_role to devgym;

grant create domain to devgym;

grant create assertion to devgym;

grant create mining model to devgym;
