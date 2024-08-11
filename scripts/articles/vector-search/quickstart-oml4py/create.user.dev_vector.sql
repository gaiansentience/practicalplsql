create user DEV_VECTOR identified by oracle;

grant connect, DB_DEVELOPER_ROLE to DEV_VECTOR;
grant create domain to DEV_VECTOR;
grant create mining model to DEV_VECTOR;

alter user DEV_VECTOR quota unlimited on users;

--Oracle 23ai VirtualBox Linux Appliance with external data path
create or replace directory ML_MODELS_DIR as '/home/oracle/ext-data/ora-db-directories/shared/ml-models';

grant read on directory ML_MODELS_DIR to DEV_VECTOR;
grant write on directory ML_MODELS_DIR to DEV_VECTOR;
