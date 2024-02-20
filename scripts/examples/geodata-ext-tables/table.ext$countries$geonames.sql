prompt geonames datasets from geonames.org under opensource attribution license
prompt dataset downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-countries
prompt opensoft url https://kering-group.opendatasoft.com/explore/dataset/geonames-countries/information/
prompt there are minor changes to csv header to allow use as external table
prompt geojson shape for polygon and multipolygon elided due to size

--"COUNTRY_CODE"|"COUNTRY_NAME"|"CAPITAL_CITY"|"POPULATION"|"CONTINENT_CODE"|"CURRENCY_CODE"|"CURRENCY_NAME"|"POSTAL_CODE_FORMAT"|"POSTAL_CODE_REGEX"

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$countries$geonames;
CREATE TABLE ext$countries$geonames 
( COUNTRY_CODE VARCHAR2(20),
  COUNTRY_NAME VARCHAR2(100),
  CAPITAL_CITY VARCHAR2(100),
  POPULATION NUMBER(38),
  CONTINENT_CODE VARCHAR2(10),
  CURRENCY_CODE VARCHAR2(20),
  CURRENCY_NAME VARCHAR2(50),
  POSTAL_CODE_FORMAT VARCHAR2(128),
  POSTAL_CODE_REGEX VARCHAR2(256)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'countries-geonames.bad'
           DISCARDFILE ETL_STAGE_DIR:'countries-geonames.discard'
           LOGFILE ETL_STAGE_DIR:'countries-geonames.log'           
           skip 6
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( COUNTRY_CODE CHAR(4000),
             COUNTRY_NAME CHAR(4000),
             CAPITAL_CITY CHAR(4000),
             POPULATION CHAR(4000),
             CONTINENT_CODE CHAR(4000),
             CURRENCY_CODE CHAR(4000),
             CURRENCY_NAME CHAR(4000),
             POSTAL_CODE_FORMAT CHAR(4000),
             POSTAL_CODE_REGEX CHAR(4000)
           )
       )
     LOCATION ('countries-geonames.csv')
  )
  REJECT LIMIT UNLIMITED;

select * from ext$countries$geonames  WHERE ROWNUM <= 5;


