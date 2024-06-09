--drop the external table definition if recreating
declare
    i number;
    l_table varchar2(100) := 'ext$postal_codes$simplemaps';
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
CREATE TABLE ext$postal_codes$simplemaps 
( 
    POSTAL_CODE VARCHAR2(50 CHAR),
    CITY_NAME VARCHAR2(100 CHAR),
    COUNTY_NAME VARCHAR2(100 CHAR),
    STATE_PROVINCE_CODE VARCHAR2(100 CHAR),
    STATE_PROVINCE_NAME VARCHAR2(100 CHAR),
    COUNTRY_CODE VARCHAR2(100 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    LATITUDE NUMBER(38),
    LONGITUDE NUMBER(38),
    CONTINENT VARCHAR2(100 CHAR)
)
ORGANIZATION EXTERNAL
  (  TYPE ORACLE_LOADER
     DEFAULT DIRECTORY GEODATA_DIR
     ACCESS PARAMETERS 
       (records delimited BY '\r\n' CHARACTERSET AL32UTF8
           BADFILE GEODATA_DIR:'postal-codes-simplemaps-na-us.bad'
           DISCARDFILE GEODATA_DIR:'postal-codes-simplemaps-na-us.discard'
           LOGFILE GEODATA_DIR:'postal-codes-simplemaps-na-us.log'
           skip 4 
           fields terminated BY '|'
           OPTIONALLY ENCLOSED BY '"' AND '"'
           lrtrim
           missing field VALUES are NULL
           ( 
            POSTAL_CODE CHAR(4000),
            CITY_NAME CHAR(4000),
            COUNTY_NAME CHAR(4000),
            STATE_PROVINCE_CODE CHAR(4000),
            STATE_PROVINCE_NAME CHAR(4000),
            COUNTRY_CODE CHAR(4000),
            COUNTRY_NAME CHAR(4000),
            LATITUDE CHAR(4000),
            LONGITUDE CHAR(4000),
            CONTINENT CHAR(4000)
           )
       )
     LOCATION ('postal-codes-simplemaps-na-us.csv')
  )
  REJECT LIMIT UNLIMITED;

select * from ext$postal_codes$simplemaps WHERE ROWNUM <= 5;


