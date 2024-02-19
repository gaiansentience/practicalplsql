prompt geonames datasets sourced from geonames.org under opensource attribution license
prompt geonames datasets downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-all-cities-with-a-population-1000@public
prompt opensoft url https://data.opendatasoft.com/explore/dataset/geonames-all-cities-with-a-population-1000%40public/information/
prompt there are minor changes to csv header to allow use as external table

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$cities$geonames;
CREATE TABLE ext$cities$geonames 
( Geoname_ID NUMBER(38),
  Name VARCHAR2(100),
  ASCII_Name VARCHAR2(100),
  Alternate_Names VARCHAR2(4000),
  Feature_Class VARCHAR2(26),
  Feature_Code VARCHAR2(26),
  Country_code_ISO2 VARCHAR2(10),
  Country_name_EN VARCHAR2(100),
  Country_Code_2 VARCHAR2(100),
  Admin1_Code VARCHAR2(50),
  Admin2_Code VARCHAR2(50),
  Admin3_Code VARCHAR2(50),
  Admin4_Code VARCHAR2(50),
  Population NUMBER(38),
  Elevation VARCHAR2(26),
  DIgital_Elevation_Model NUMBER(38),
  Time_zone_name VARCHAR2(50),
  Modification_date DATE,
  LABEL_EN VARCHAR2(100),
  Coordinates VARCHAR2(128))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'geonames-cities.bad'
           DISCARDFILE ETL_STAGE_DIR:'geonames-cities.discard'
           LOGFILE ETL_STAGE_DIR:'geonames-cities.log'
           skip 6 
           fields terminated BY ';'
           lrtrim
           missing field VALUES are NULL
           ( Geoname_ID CHAR(4000),
             Name CHAR(4000),
             ASCII_Name CHAR(4000),
             Alternate_Names CHAR(4000),
             Feature_Class CHAR(4000),
             Feature_Code CHAR(4000),
             Country_code_ISO2 CHAR(4000),
             Country_name_EN CHAR(4000),
             Country_Code_2 CHAR(4000),
             Admin1_Code CHAR(4000),
             Admin2_Code CHAR(4000),
             Admin3_Code CHAR(4000),
             Admin4_Code CHAR(4000),
             Population CHAR(4000),
             Elevation CHAR(4000),
             DIgital_Elevation_Model CHAR(4000),
             Time_zone_name CHAR(4000),
             Modification_date CHAR(4000) date_format DATE mask "YYYY-MM-DD",
             LABEL_EN CHAR(4000),
             Coordinates CHAR(4000)
           )
       )
     LOCATION ('geonames-cities.csv')
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$cities$geonames WHERE ROWNUM <= 5;


