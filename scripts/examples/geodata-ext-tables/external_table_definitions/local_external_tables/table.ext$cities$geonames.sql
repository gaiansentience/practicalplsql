--drop the external table definition if recreating
declare
    i number;
    l_table varchar2(100) := 'ext$cities$geonames';
begin

$if dbms_db_version.version >= 23 $then
    execute immediate 'drop table if exists ' || l_table;
$else
    --Use Pre 23 syntax to conditionally drop table
    select count(*)
    into i
    from user_tables 
    where table_name = upper(l_table);
    
    if i > 0 then
        execute immediate 'drop table ' || l_table;
    end if;
$end

end;
/


CREATE TABLE ext$cities$geonames 
( 
    CITY_NAME VARCHAR2(100 CHAR),
    CITY_NAME_UNICODE VARCHAR2(100 CHAR),
    COUNTRY_CODE VARCHAR2(10 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    POPULATION NUMBER(38),
    TIME_ZONE_NAME VARCHAR2(50 CHAR),
    LATITUDE NUMBER(38),
    LONGITUDE NUMBER(38)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY GEODATA_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
           BADFILE GEODATA_DIR:'cities-geonames.bad'
           DISCARDFILE GEODATA_DIR:'cities-geonames.discard'
           LOGFILE GEODATA_DIR:'cities-geonames.log'
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
     LOCATION (
        'cities-geonames-1.csv', 
        'cities-geonames-2.csv', 
        'cities-geonames-3.csv',
        'cities-geonames-4.csv'
        )
  )
  REJECT LIMIT UNLIMITED;

select * from ext$cities$geonames WHERE ROWNUM <= 5;


