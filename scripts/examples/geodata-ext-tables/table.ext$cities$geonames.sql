prompt geonames datasets sourced from geonames.org under opensource attribution license
prompt geonames datasets downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-all-cities-with-a-population-1000@public
prompt opensoft url https://data.opendatasoft.com/explore/dataset/geonames-all-cities-with-a-population-1000%40public/information/
prompt there are minor changes to csv header to allow use as external table
--"CITY_NAME"|"CITY_NAME_UNICODE"|"COUNTRY_CODE"|"COUNTRY_NAME"|"POPULATION"|"TIME_ZONE_NAME"|"LATITUDE"|"LONGITUDE"

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$cities$geonames;
CREATE TABLE ext$cities$geonames 
( 
  CITY_NAME VARCHAR2(100),
  CITY_NAME_UNICODE VARCHAR2(100),
  COUNTRY_CODE VARCHAR2(10),
  COUNTRY_NAME VARCHAR2(100),
  POPULATION NUMBER(38),
  TIME_ZONE_NAME VARCHAR2(50),
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
           BADFILE ETL_STAGE_DIR:'cities-geonames.bad'
           DISCARDFILE ETL_STAGE_DIR:'cities-geonames.discard'
           LOGFILE ETL_STAGE_DIR:'cities-geonames.log'
           skip 6 
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
     LOCATION ('cities-geonames.csv')
  )
  REJECT LIMIT UNLIMITED;

select * from ext$cities$geonames WHERE ROWNUM <= 5;


