prompt design--9.4-dynamic_json-test-19c.sql
prompt query is 19c compatibale: uses clob for json_data
prompt dynamic_json conditionally compiled to use clob for json data

column row#id format 9
column column#key format a20
column column#value format a20
set pagesize 100


with base as (
    select 
        object_id, 
        object_name, 
        object_type, 
        created, 
        namespace
    from user_objects
), to_json as (
    select 
        json_arrayagg(
            json_object(b.* returning clob)
        returning clob) as jdoc
    from base b
)
select u.*
from 
    to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, row_identifier => 'OBJECT_ID') u
/

/*
design--9.4-dynamic_json-test-19c.sql
query is 19c compatibale: uses clob for json_data
dynamic_json conditionally compiled to use clob for json data

ROW#ID COLUMN#KEY           COLUMN#VALUE        
------ -------------------- --------------------
108369 CREATED              2024-07-04T19:31:58 
108369 NAMESPACE            1                   
108369 OBJECT_NAME          DYNAMIC_JSON        
108369 OBJECT_TYPE          PACKAGE             
108370 CREATED              2024-07-04T19:32:52 
108370 NAMESPACE            2                   
108370 OBJECT_NAME          DYNAMIC_JSON        
108370 OBJECT_TYPE          PACKAGE BODY        
108399 CREATED              2024-07-04T19:00:55 
108399 NAMESPACE            1                   
108399 OBJECT_NAME          DYNAMIC_JSON#TEST   
108399 OBJECT_TYPE          PACKAGE             
108400 CREATED              2024-07-04T19:00:55 
108400 NAMESPACE            2                   
108400 OBJECT_NAME          DYNAMIC_JSON#TEST   
108400 OBJECT_TYPE          PACKAGE BODY        
108401 CREATED              2024-07-04T19:21:42 
108401 NAMESPACE            1                   
108401 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
108401 OBJECT_TYPE          PACKAGE             
108402 CREATED              2024-07-04T19:21:42 
108402 NAMESPACE            2                   
108402 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
108402 OBJECT_TYPE          PACKAGE BODY        
108403 CREATED              2024-07-04T19:26:16 
108403 NAMESPACE            1                   
108403 OBJECT_NAME          DYNAMIC_JSON#BETA   
108403 OBJECT_TYPE          PACKAGE             
108404 CREATED              2024-07-04T19:26:16 
108404 NAMESPACE            2                   
108404 OBJECT_NAME          DYNAMIC_JSON#BETA   
108404 OBJECT_TYPE          PACKAGE BODY        

32 rows selected. 


*/