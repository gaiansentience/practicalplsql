prompt geonames datasets from geonames.org under opensource attribution license
prompt dataset downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-countries
prompt opensoft url https://kering-group.opendatasoft.com/explore/dataset/geonames-countries/information/
prompt there are minor changes to csv header to allow use as external table
prompt geojson shape for polygon and multipolygon elided due to size

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$countries$geonames;
CREATE TABLE ext$countries$geonames 
( Country_Code_ISO2 VARCHAR2(10),
  Country_Code_ISO3 VARCHAR2(10),
  ISO_Numeric VARCHAR2(26),
  fips VARCHAR2(26),
  Impact_Country VARCHAR2(128),
  Capital VARCHAR2(100),
  Area NUMBER(38),
  Population NUMBER(38),
  Continent VARCHAR2(50),
  tld VARCHAR2(26),
  Currency_Code VARCHAR2(20),
  Currency_Name VARCHAR2(50),
  Phone VARCHAR2(50),
  Postal_Code_Format VARCHAR2(128),
  Postal_Code_Regex VARCHAR2(256),
  Languages VARCHAR2(128),
  Geonameid NUMBER(38),
  Neighbours VARCHAR2(128),
  Equivalent_Fips_Code VARCHAR2(26),
  Geo_Shape clob,
  Geo_Point VARCHAR2(128))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'geonames-countries.bad'
           DISCARDFILE ETL_STAGE_DIR:'geonames-countries.discard'
           LOGFILE ETL_STAGE_DIR:'geonames-countries.log'           
           skip 7
           fields terminated BY ';'
           lrtrim
           missing field VALUES are NULL
           ( Country_Code_ISO2 CHAR(4000),
             Country_Code_ISO3 CHAR(4000),
             ISO_Numeric CHAR(4000),
             fips CHAR(4000),
             Impact_Country CHAR(4000),
             Capital CHAR(4000),
             Area CHAR(4000),
             Population CHAR(4000),
             Continent CHAR(4000),
             tld CHAR(4000),
             Currency_Code CHAR(4000),
             Currency_Name CHAR(4000),
             Phone CHAR(4000),
             Postal_Code_Format CHAR(4000),
             Postal_Code_Regex CHAR(4000),
             Languages CHAR(4000),
             Geonameid CHAR(4000),
             Neighbours CHAR(4000),
             Equivalent_Fips_Code CHAR(4000),
             Geo_Shape CHAR(4000),
             Geo_Point CHAR(4000)
           )
       )
     LOCATION ('geonames-countries.csv')
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$countries$geonames  WHERE ROWNUM <= 5;


