prompt geonames datasets sourced from geonames.org under opensource attribution license
prompt geonames datasets downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier airports-code@public
prompt opensoft url https://data.opendatasoft.com/explore/dataset/airports-code%40public/export/
prompt there are minor changes to csv header to allow use as external table

--SET DEFINE OFF
--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$airports$geonames;
CREATE TABLE ext$airports$geonames 
( Airport_Code VARCHAR2(26),
  Airport_Name VARCHAR2(200),
  City_Name VARCHAR2(100),
  Country_Name VARCHAR2(100),
  Country_Code_iso2 VARCHAR2(20),
  Latitude NUMBER(38),
  Longitude NUMBER(38),
  World_Area_Code NUMBER(38),
  City_Name_geo_name_id VARCHAR2(26),
  Country_Name_geo_name_id NUMBER(38),
  coordinates VARCHAR2(128))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'geonames-airports.bad'
           DISCARDFILE ETL_STAGE_DIR:'geonames-airports.discard'
           LOGFILE ETL_STAGE_DIR:'geonames-airports.log'
           skip 2 
           fields terminated BY ';'
           lrtrim
           missing field VALUES are NULL
           ( Airport_Code CHAR(4000),
             Airport_Name CHAR(4000),
             City_Name CHAR(4000),
             Country_Name CHAR(4000),
             Country_Code_iso2 CHAR(4000),
             Latitude CHAR(4000),
             Longitude CHAR(4000),
             World_Area_Code CHAR(4000),
             City_Name_geo_name_id CHAR(4000),
             Country_Name_geo_name_id CHAR(4000),
             coordinates CHAR(4000)
           )
       )
     LOCATION ('geonames-airports.csv')
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$airports$geonames WHERE ROWNUM <= 5;


