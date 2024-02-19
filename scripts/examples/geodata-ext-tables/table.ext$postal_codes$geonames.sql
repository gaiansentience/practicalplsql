prompt geonames datasets sourced from geonames.org under opensource attribution license
prompt geonames datasets downloaded from https://data.opendatasoft.com
prompt opendatasoft dataset identifier geonames-postal-code
prompt opensoft url https://public.opendatasoft.com/explore/dataset/geonames-postal-code/information/
prompt there are minor changes to csv header to allow use as external table

--CREATE OR REPLACE DIRECTORY ETL_STAGE_DIR AS 'X:\ora-db-directories\shared\etl-stage';
--GRANT READ ON DIRECTORY ETL_STAGE_DIR TO USER;
--GRANT WRITE ON DIRECTORY ETL_STAGE_DIR TO USER;
--drop table ext$postal_codes$geonames;
CREATE TABLE ext$postal_codes$geonames 
( country_code_iso2 VARCHAR2(26),
  postal_code VARCHAR2(26),
  place_name VARCHAR2(100),
  admin_name1 VARCHAR2(100),
  admin_code1 VARCHAR2(100),
  admin_name2 VARCHAR2(100),
  admin_code2 VARCHAR2(100),
  admin_name3 VARCHAR2(100),
  admin_code3 VARCHAR2(100),
  latitude NUMBER(38),
  longitude NUMBER(38),
  accuracy NUMBER(38),
  coordinates VARCHAR2(128))
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY ETL_STAGE_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
--           NOBADFILE
--           NODISCARDFILE
--           NOLOGFILE
           BADFILE ETL_STAGE_DIR:'geonames-postal-codes.bad'
           DISCARDFILE ETL_STAGE_DIR:'geonames-postal-codes.discard'
           LOGFILE ETL_STAGE_DIR:'geonames-postal-codes.log'           
           skip 6
           fields terminated BY ';'
           lrtrim
           missing field VALUES are NULL
           ( country_code_iso2 CHAR(4000),
             postal_code CHAR(4000),
             place_name CHAR(4000),
             admin_name1 CHAR(4000),
             admin_code1 CHAR(4000),
             admin_name2 CHAR(4000),
             admin_code2 CHAR(4000),
             admin_name3 CHAR(4000),
             admin_code3 CHAR(4000),
             latitude CHAR(4000),
             longitude CHAR(4000),
             accuracy CHAR(4000),
             coordinates CHAR(4000)
           )
       )
     LOCATION (
        'geonames-postal-codes-1.csv', 
        'geonames-postal-codes-2.csv'
        'geonames-postal-codes-3.csv'
        'geonames-postal-codes-4.csv'
        )
  )
  REJECT LIMIT UNLIMITED;

--select * from ext$postal_codes$geonames WHERE ROWNUM <= 5;

