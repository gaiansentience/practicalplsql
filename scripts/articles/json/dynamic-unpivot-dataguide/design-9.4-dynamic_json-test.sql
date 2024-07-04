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
        status, 
        created, 
        timestamp, 
        namespace, 
        editionable
    from user_objects
), to_json as (
    select 
        json(
            json_arrayagg(
                json_object(b.*)
            )
        ) as jdoc
    from base b
)
select u.*
from 
    to_json j,
    dynamic_json.unpivot_json_array(j.jdoc, row_identifier => 'OBJECT_ID') u
/

/*
design--9.4-dynamic_json-test.sql

ROW#ID COLUMN#KEY           COLUMN#VALUE        
------ -------------------- --------------------
100457 CREATED              2024-07-04T13:05:32 
100457 EDITIONABLE          Y                   
100457 NAMESPACE            1                   
100457 OBJECT_NAME          DYNAMIC_JSON#TEST   
100457 OBJECT_TYPE          PACKAGE             
100457 STATUS               VALID               
100457 TIMESTAMP            2024-07-04:16:34:17 
100458 CREATED              2024-07-04T13:05:33 
100458 EDITIONABLE          Y                   
100458 NAMESPACE            2                   
100458 OBJECT_NAME          DYNAMIC_JSON#TEST   
100458 OBJECT_TYPE          PACKAGE BODY        
100458 STATUS               VALID               
100458 TIMESTAMP            2024-07-04:16:35:59 
100459 CREATED              2024-07-04T16:53:42 
100459 EDITIONABLE          Y                   
100459 NAMESPACE            1                   
100459 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
100459 OBJECT_TYPE          PACKAGE             
100459 STATUS               VALID               
100459 TIMESTAMP            2024-07-04:16:54:53 
100460 CREATED              2024-07-04T16:53:42 
100460 EDITIONABLE          Y                   
100460 NAMESPACE            2                   
100460 OBJECT_NAME          DYNAMIC_JSON#ALPHA  
100460 OBJECT_TYPE          PACKAGE BODY        
100460 STATUS               VALID               
100460 TIMESTAMP            2024-07-04:16:56:08 
100461 CREATED              2024-07-04T17:09:40 
100461 EDITIONABLE          Y                   
100461 NAMESPACE            1                   
100461 OBJECT_NAME          DYNAMIC_JSON#BETA   
100461 OBJECT_TYPE          PACKAGE             
100461 STATUS               VALID               
100461 TIMESTAMP            2024-07-04:17:37:15 
100462 CREATED              2024-07-04T17:09:40 
100462 EDITIONABLE          Y                   
100462 NAMESPACE            2                   
100462 OBJECT_NAME          DYNAMIC_JSON#BETA   
100462 OBJECT_TYPE          PACKAGE BODY        
100462 STATUS               VALID               
100462 TIMESTAMP            2024-07-04:17:42:35 
100463 CREATED              2024-07-04T17:58:54 
100463 EDITIONABLE          Y                   
100463 NAMESPACE            1                   
100463 OBJECT_NAME          DYNAMIC_JSON        
100463 OBJECT_TYPE          PACKAGE             
100463 STATUS               VALID               
100463 TIMESTAMP            2024-07-04:17:58:54 
100464 CREATED              2024-07-04T17:59:00 
100464 EDITIONABLE          Y                   
100464 NAMESPACE            2                   
100464 OBJECT_NAME          DYNAMIC_JSON        
100464 OBJECT_TYPE          PACKAGE BODY        
100464 STATUS               VALID               
100464 TIMESTAMP            2024-07-04:18:11:44 

56 rows selected. 

*/