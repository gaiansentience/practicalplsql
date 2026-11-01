--create.directory.ml_models_dir.sql

--from create.user.practicalplsql.sql

--run as sys

create or replace directory 
    ml_models_dir as '/home/oracle/ext-data/ora-db-directories/shared/ml-models';

grant read on directory ml_models_dir to practicalplsql;
grant write on directory ml_models_dir to practicalplsql;

grant read on directory ml_models_dir to dev_vector;
grant write on directory ml_models_dir to dev_vector;
