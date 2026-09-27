--run as sys

--Oracle 23ai VirtualBox Linux Appliance with external data path
create or replace directory 
    ml_models_dir as '/home/oracle/ext-data/ora-db-directories/shared/ml-models';

grant read on directory ml_models_dir to practicalplsql;
grant write on directory ml_models_dir to practicalplsql;