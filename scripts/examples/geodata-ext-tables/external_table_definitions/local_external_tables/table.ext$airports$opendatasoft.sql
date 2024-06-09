--drop the external table definition if recreating
declare
    i number;
    l_table varchar2(100) := 'ext$airports$opendatasoft';
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

CREATE TABLE ext$airports$opendatasoft 
( 
    AIRPORT_CODE VARCHAR2(20 CHAR),
    AIRPORT_NAME VARCHAR2(200 CHAR),
    CITY_NAME VARCHAR2(100 CHAR),
    COUNTRY_CODE VARCHAR2(20 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    COORDINATES VARCHAR2(100 CHAR),
    LATITUDE NUMBER(38),
    LONGITUDE NUMBER(38)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY GEODATA_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
           BADFILE GEODATA_DIR:'airports-opendatasoft.bad'
           DISCARDFILE GEODATA_DIR:'airports-opendatasoft.discard'
           LOGFILE GEODATA_DIR:'airports-opendatasoft.log'
           skip 5 
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( 
            AIRPORT_CODE CHAR(4000),
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


