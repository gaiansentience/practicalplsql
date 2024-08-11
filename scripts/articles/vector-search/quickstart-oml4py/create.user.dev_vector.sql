create user dev_vector identified by oracle;

grant connect, db_developer_role to dev_vector;
grant create mining model to dev_vector;

alter user dev_vector quota unlimited on users;

--Oracle 23ai VirtualBox Linux Appliance with external data path
create or replace directory 
    ml_models_dir as '/home/oracle/ext-data/ora-db-directories/shared/ml-models';

grant read on directory ml_models_dir to dev_vector;
grant write on directory ml_models_dir to dev_vector;
