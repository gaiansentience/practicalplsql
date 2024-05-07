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


DECLARE
  l_TABLE_NAME        DBMS_QUOTED_ID := 'EXT$COUNTRIES$GEONAMES';
  l_CREDENTIAL_NAME   DBMS_QUOTED_ID := '"OCI$RESOURCE_PRINCIPAL"';
  l_FILE_URI_LIST     CLOB :=
    q'['https://objectstorage.us-phoenix-1.oraclecloud.com/n/axggbt93rsku/b/adw_ext_data/o/geodata/countries-geonames.csv']';
  l_COLUMN_LIST       CLOB :=
    q'[
    COUNTRY_CODE VARCHAR2(20 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    CAPITAL_CITY VARCHAR2(100 CHAR),
    POPULATION NUMBER(38),
    CONTINENT_CODE VARCHAR2(10 CHAR),
    CURRENCY_CODE VARCHAR2(20 CHAR),
    CURRENCY_NAME VARCHAR2(50 CHAR),
    POSTAL_CODE_FORMAT VARCHAR2(128 CHAR),
    POSTAL_CODE_REGEX VARCHAR2(256 CHAR)
    ]';
  l_FIELD_LIST        CLOB :=
    q'[
    COUNTRY_CODE CHAR(4000),
    COUNTRY_NAME CHAR(4000),
    CAPITAL_CITY CHAR(4000),
    POPULATION CHAR(4000),
    CONTINENT_CODE CHAR(4000),
    CURRENCY_CODE CHAR(4000),
    CURRENCY_NAME CHAR(4000),
    POSTAL_CODE_FORMAT CHAR(4000),
    POSTAL_CODE_REGEX CHAR(4000)
    ]';
  l_FORMAT            CLOB :=
    '{
       "delimiter" : "|",
       "ignoremissingcolumns" : true,
       "ignoreblanklines" : true,
       "blankasnull" : true,
       "rejectlimit" : 10000,
       "trimspaces" : "lrtrim",
       "quote" : "\"",
       "characterset" : "AL32UTF8",
       "skipheaders" : 6,
       "logretention" : 7,
       "recorddelimiter" : "detected newline"
     }';
BEGIN
  "C##CLOUD$SERVICE"."DBMS_CLOUD"."CREATE_EXTERNAL_TABLE"
  ( TABLE_NAME        => l_TABLE_NAME
   ,CREDENTIAL_NAME   => l_CREDENTIAL_NAME
   ,FILE_URI_LIST     => l_FILE_URI_LIST
   ,COLUMN_LIST       => l_COLUMN_LIST
   ,FIELD_LIST        => l_FIELD_LIST
   ,FORMAT            => l_FORMAT
  );
END;
/

DECLARE
  l_TABLE_NAME                 DBMS_QUOTED_ID := 'EXT$COUNTRIES$GEONAMES';
  l_OPERATION_ID               NUMBER; /* OUT */
  l_ROWCOUNT                   NUMBER := 1000000;
  l_STOP_ON_ERROR              BOOLEAN := false;
BEGIN
  "C##CLOUD$SERVICE"."DBMS_CLOUD"."VALIDATE_EXTERNAL_TABLE"
  ( TABLE_NAME                 => l_TABLE_NAME
   ,OPERATION_ID               => l_OPERATION_ID
   ,ROWCOUNT                   => l_ROWCOUNT
   ,STOP_ON_ERROR              => l_STOP_ON_ERROR
  );
END;
/