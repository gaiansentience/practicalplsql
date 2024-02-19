prompt datafile is based on free download from simplemaps.com, under opensource attribution license 
prompt csv file exported from https://simplemaps.com/data/us-zips
prompt there are minor changes to csv header to allow use as external table

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$postal_codes$simplemaps;
CREATE TABLE ext$postal_codes$simplemaps 
( zip VARCHAR2(50),
  lat NUMBER(38),
  lng NUMBER(38),
  city VARCHAR2(100),
  state_id VARCHAR2(26),
  state_name VARCHAR2(100),
  zcta VARCHAR2(26),
  parent_zcta VARCHAR2(26),
  population NUMBER(38),
  density NUMBER(38),
  county_fips NUMBER(38),
  county_name VARCHAR2(26),
  county_weights VARCHAR2(128),
  county_names_all VARCHAR2(128),
  county_fips_all VARCHAR2(128),
  imprecise VARCHAR2(26),
  military VARCHAR2(26),
  time_zone_name VARCHAR2(26))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'simplemaps-postal-codes-us.bad'
           DISCARDFILE ETL_STAGE_DIR:'simplemaps-postal-codes-us.discard'
           LOGFILE ETL_STAGE_DIR:'simplemaps-postal-codes-us.log'
           skip 4 
           fields terminated BY ','
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( zip CHAR(4000),
             lat CHAR(4000),
             lng CHAR(4000),
             city CHAR(4000),
             state_id CHAR(4000),
             state_name CHAR(4000),
             zcta CHAR(4000),
             parent_zcta CHAR(4000),
             population CHAR(4000),
             density CHAR(4000),
             county_fips CHAR(4000),
             county_name CHAR(4000),
             county_weights CHAR(4000),
             county_names_all CHAR(4000),
             county_fips_all CHAR(4000),
             imprecise CHAR(4000),
             military CHAR(4000),
             time_zone_name CHAR(4000)
           )
       )
     LOCATION ('simplemaps-postal-codes-us.csv')
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$postal_codes$simplemaps WHERE ROWNUM <= 5;


