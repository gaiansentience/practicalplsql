--drop the external table definition if recreating
declare
    i number;
    l_table varchar2(100) := 'ext$cities$simplemaps';
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

CREATE TABLE ext$cities$simplemaps 
( 
    CITY_NAME VARCHAR2(100 CHAR),
    CITY_NAME_UNICODE VARCHAR2(100 CHAR),
    COUNTRY_CODE VARCHAR2(10 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    POPULATION NUMBER(38),
    LATITUDE NUMBER(38),
    LONGITUDE NUMBER(38)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY GEODATA_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
           BADFILE GEODATA_DIR:'cities-simplemaps.bad'
           DISCARDFILE GEODATA_DIR:'cities-simplemaps.discard'
           LOGFILE GEODATA_DIR:'cities-simplemaps.log'
           skip 5
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
            LATITUDE CHAR(4000),
            LONGITUDE CHAR(4000)
           )
       )
     LOCATION ('cities-simplemaps.csv')
  )
  REJECT LIMIT UNLIMITED;


select * from ext$cities$simplemaps WHERE ROWNUM <= 5;


