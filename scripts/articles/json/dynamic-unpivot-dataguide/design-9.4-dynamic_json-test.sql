prompt design--9.4-dynamic_json-test.sql
prompt query uses json constructor, only valid for 21c and higher

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
    select json [ json { b.* } ] as jdoc
    from base b
)
select u.*
from 
    to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, row_identifier => 'OBJECT_ID') u
/

/*
design--9.4-dynamic_json-test.sql
query uses json constructor, only valid for 21c and higher

ROW#ID COLUMN#KEY           COLUMN#VALUE        
------ -------------------- --------------------
100457 CREATED              2024-07-04T19:01:22 
100457 NAMESPACE            1                   
100457 OBJECT_NAME          DYNAMIC_JSON#TEST   
100457 OBJECT_TYPE          PACKAGE             
100458 CREATED              2024-07-04T19:01:22 
100458 NAMESPACE            2                   
100458 OBJECT_NAME          DYNAMIC_JSON#TEST   
100458 OBJECT_TYPE          PACKAGE BODY        
100459 CREATED              2024-07-04T19:22:51 
100459 NAMESPACE            1                   
100459 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
100459 OBJECT_TYPE          PACKAGE             
100460 CREATED              2024-07-04T19:22:51 
100460 NAMESPACE            2                   
100460 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
100460 OBJECT_TYPE          PACKAGE BODY        
100461 CREATED              2024-07-04T19:30:24 
100461 NAMESPACE            1                   
100461 OBJECT_NAME          DYNAMIC_JSON#BETA   
100461 OBJECT_TYPE          PACKAGE             
100462 CREATED              2024-07-04T19:30:24 
100462 NAMESPACE            2                   
100462 OBJECT_NAME          DYNAMIC_JSON#BETA   
100462 OBJECT_TYPE          PACKAGE BODY        
100463 CREATED              2024-07-04T19:32:40 
100463 NAMESPACE            1                   
100463 OBJECT_NAME          DYNAMIC_JSON        
100463 OBJECT_TYPE          PACKAGE             
100464 CREATED              2024-07-04T19:36:20 
100464 NAMESPACE            2                   
100464 OBJECT_NAME          DYNAMIC_JSON        
100464 OBJECT_TYPE          PACKAGE BODY        

32 rows selected. 


*/