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


DECLARE
  l_TABLE_NAME        DBMS_QUOTED_ID := 'EXT$AIRPORTS$OPENDATASOFT';
  --create resource principle for OCI Autonomous database and grant to user along with execute rights on dbms_cloud
  l_CREDENTIAL_NAME   DBMS_QUOTED_ID := '"OCI$RESOURCE_PRINCIPAL"';
  --point to the file on OCI object storyage
  l_FILE_URI_LIST     CLOB :=
    q'['https://objectstorage.us-ashburn-1.oraclecloud.com/n/idjv1ptikjf5/b/adw_ext_data/o/geodata/airports-opendatasoft.csv']';
  l_COLUMN_LIST       CLOB :=
    q'[
    AIRPORT_CODE VARCHAR2(20 CHAR),
    AIRPORT_NAME VARCHAR2(200 CHAR),
    CITY_NAME VARCHAR2(100 CHAR),
    COUNTRY_CODE VARCHAR2(20 CHAR),
    COUNTRY_NAME VARCHAR2(100 CHAR),
    COORDINATES VARCHAR2(100 CHAR),
    LATITUDE NUMBER(38),
    LONGITUDE NUMBER(38)
    ]';
  l_FIELD_LIST        CLOB :=
    q'[
    AIRPORT_CODE CHAR(4000),
    AIRPORT_NAME CHAR(4000),
    CITY_NAME CHAR(4000),
    COUNTRY_CODE CHAR(4000),
    COUNTRY_NAME CHAR(4000),
    COORDINATES CHAR(4000),
    LATITUDE CHAR(4000),
    LONGITUDE CHAR(4000)
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
       "skipheaders" : 5,
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
  l_TABLE_NAME                 DBMS_QUOTED_ID := 'EXT$AIRPORTS$OPENDATASOFT';
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