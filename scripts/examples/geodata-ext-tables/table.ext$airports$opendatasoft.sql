prompt public dataset downloaded from https://data.openopendatasoft.com
prompt openopendatasoft dataset identifier airports-code@public
prompt opensoft url https://data.openopendatasoft.com/explore/dataset/airports-code%40public/export/
prompt there are minor changes to csv header to allow use as external table

--"AIRPORT_CODE"|"AIRPORT_NAME"|"CITY_NAME"|"COUNTRY_CODE"|"COUNTRY_NAME"|"COORDINATES"|"LATITUDE"|"LONGITUDE"


--SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$airports$opendatasoft;
CREATE TABLE ext$airports$opendatasoft 
( AIRPORT_CODE VARCHAR2(20),
  AIRPORT_NAME VARCHAR2(200),
  CITY_NAME VARCHAR2(100),
  COUNTRY_CODE VARCHAR2(20),
  COUNTRY_NAME VARCHAR2(100),
  COORDINATES VARCHAR2(100),
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
           BADFILE ETL_STAGE_DIR:'airports-opendatasoft.bad'
           DISCARDFILE ETL_STAGE_DIR:'airports-opendatasoft.discard'
           LOGFILE ETL_STAGE_DIR:'airports-opendatasoft.log'
           skip 5 
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( AIRPORT_CODE CHAR(4000),
             AIRPORT_NAME CHAR(4000),
             CITY_NAME CHAR(4000),
             COUNTRY_CODE CHAR(4000),
             COUNTRY_NAME CHAR(4000),
             COORDINATES CHAR(4000),
             LATITUDE CHAR(4000),
             LONGITUDE CHAR(4000)
           )
       )
     LOCATION ('airports-opendatasoft.csv')
  )
  REJECT LIMIT UNLIMITED;

select * from ext$airports$opendatasoft WHERE ROWNUM <= 5;


