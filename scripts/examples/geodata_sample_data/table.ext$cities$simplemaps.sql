prompt datafile is based on free download from simplemaps.com, under opensource attribution license 
prompt csv file exported from https://simplemaps.com/data/world-cities
prompt there are minor changes to csv header to allow use as external table

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$cities$simplemaps;
CREATE TABLE ext$cities$simplemaps 
( city VARCHAR2(100),
  city_ascii VARCHAR2(100),
  lat NUMBER(38),
  lng NUMBER(38),
  country VARCHAR2(100),
  iso2 VARCHAR2(20),
  iso3 VARCHAR2(20),
  admin_name VARCHAR2(128),
  capital VARCHAR2(100),
  population NUMBER(38),
  id NUMBER(38))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'simplemaps-cities.bad'
           DISCARDFILE ETL_STAGE_DIR:'simplemaps-cities.discard'
           LOGFILE ETL_STAGE_DIR:'simplemaps-cities.log'
           skip 4
           fields terminated BY ','
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( city CHAR(4000),
             city_ascii CHAR(4000),
             lat CHAR(4000),
             lng CHAR(4000),
             country CHAR(4000),
             iso2 CHAR(4000),
             iso3 CHAR(4000),
             admin_name CHAR(4000),
             capital CHAR(4000),
             population CHAR(4000),
             id CHAR(4000)
           )
       )
     LOCATION ('simplemaps-cities.csv')
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$cities$simplemaps WHERE ROWNUM <= 5;


