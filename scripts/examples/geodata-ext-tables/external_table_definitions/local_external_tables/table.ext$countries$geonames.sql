--drop the external table definition if recreating
declare
    i number;
    l_table varchar2(100) := 'ext$countries$geonames';
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

CREATE TABLE ext$countries$geonames 
( 
    COUNTRY_CODE VARCHAR2(20 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    CAPITAL_CITY VARCHAR2(100 CHAR),
    POPULATION NUMBER(38),
    CONTINENT_CODE VARCHAR2(10 CHAR),
    CURRENCY_CODE VARCHAR2(20 CHAR),
    CURRENCY_NAME VARCHAR2(50 CHAR),
    POSTAL_CODE_FORMAT VARCHAR2(128 CHAR),
    POSTAL_CODE_REGEX VARCHAR2(256 CHAR)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY GEODATA_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
           BADFILE GEODATA_DIR:'countries-geonames.bad'
           DISCARDFILE GEODATA_DIR:'countries-geonames.discard'
           LOGFILE GEODATA_DIR:'countries-geonames.log'           
           skip 6
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( 
            COUNTRY_CODE CHAR(4000),
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


