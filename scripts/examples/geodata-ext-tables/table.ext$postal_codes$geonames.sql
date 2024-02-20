prompt geonames datasets sourced from geonames.org under opensource attribution license
prompt geonames datasets downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-postal-code
prompt opensoft url https://public.opendatasoft.com/explore/dataset/geonames-postal-code/information/
prompt there are minor changes to csv header to allow use as external table

--"POSTAL_CODE"|"CITY_NAME"|"COUNTY_NAME"|"STATE_PROVINCE_CODE"|"COUNTRY_CODE"|"COUNTRY_NAME"|"LATITUDE"|"LONGITUDE"|"CONTINENT"

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$postal_codes$geonames;
CREATE TABLE ext$postal_codes$geonames 
( 
POSTAL_CODE VARCHAR2(50),
  CITY_NAME VARCHAR2(100),
  COUNTY_NAME VARCHAR2(100),
  STATE_PROVINCE_CODE VARCHAR2(100),
  COUNTRY_CODE VARCHAR2(100),
  COUNTRY_NAME VARCHAR2(100),
  LATITUDE NUMBER(38),
  LONGITUDE NUMBER(38),
  CONTINENT VARCHAR2(100)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'postal-codes-geonames.bad'
           DISCARDFILE ETL_STAGE_DIR:'postal-codes-geonames.discard'
           LOGFILE ETL_STAGE_DIR:'postal-codes-geonames.log'           
           skip 6
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           (
           POSTAL_CODE CHAR(4000),
             CITY_NAME CHAR(4000),
             COUNTY_NAME CHAR(4000),
             STATE_PROVINCE_CODE CHAR(4000),
             COUNTRY_CODE CHAR(4000),
             COUNTRY_NAME CHAR(4000),
             LATITUDE CHAR(4000),
             LONGITUDE CHAR(4000),
             CONTINENT CHAR(4000)
           )
       )
     LOCATION (
        'postal-codes-geonames-na-us.csv',
        'postal-codes-geonames-af.csv',
        'postal-codes-geonames-as.csv',
        'postal-codes-geonames-eu.csv',     
        'postal-codes-geonames-na-etc.csv', 
        'postal-codes-geonames-oc.csv',
        'postal-codes-geonames-sa.csv'
        )
  )
  REJECT LIMIT UNLIMITED;

select * from ext$postal_codes$geonames WHERE ROWNUM <= 5;

