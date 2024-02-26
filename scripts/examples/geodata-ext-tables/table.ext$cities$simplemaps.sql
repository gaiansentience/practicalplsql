prompt datafile is based on free download from simplemaps.com, under opensource attribution license 
prompt csv file exported from https://simplemaps.com/data/world-cities
prompt there are minor changes to csv header to allow use as external table
--"CITY_NAME"|"CITY_NAME_UNICODE"|"COUNTRY_CODE"|"COUNTRY_NAME"|"POPULATION"|"LATITUDE"|"LONGITUDE"

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$cities$simplemaps;
CREATE TABLE ext$cities$simplemaps 
( 
  CITY_NAME VARCHAR2(100),
  CITY_NAME_UNICODE VARCHAR2(100),
  COUNTRY_CODE VARCHAR2(10),
  COUNTRY_NAME VARCHAR2(100),
  POPULATION NUMBER(38),
  LATITUDE NUMBER(38),
  LONGITUDE NUMBER(38)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'cities-simplemaps.bad'
           DISCARDFILE ETL_STAGE_DIR:'cities-simplemaps.discard'
           LOGFILE ETL_STAGE_DIR:'cities-simplemaps.log'
           skip 5
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           (
           CITY_NAME CHAR(4000),
             CITY_NAME_UNICODE CHAR(4000),
             COUNTRY_CODE CHAR(4000),
             COUNTRY_NAME CHAR(4000),
             POPULATION CHAR(4000),
             TIME_ZONE_NAME CHAR(4000),
             LATITUDE CHAR(4000),
             LONGITUDE CHAR(4000)
           )
       )
     LOCATION ('cities-simplemaps.csv')
  )
  REJECT LIMIT UNLIMITED;


select * from ext$cities$simplemaps WHERE ROWNUM <= 5;


