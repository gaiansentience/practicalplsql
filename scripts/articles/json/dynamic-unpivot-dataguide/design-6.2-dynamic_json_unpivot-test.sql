prompt design--6.2-dynamic_json_unpivot-test.sql

--test the pipelined function using the test json document
column row#id format 9
column column#key format a10
column column#value format a20
set pagesize 100


select *
from dynamic_json#alpha.unpivot_json_array(dynamic_json#test.test_jdoc())
/

select *
from dynamic_json#alpha.unpivot_json_array(dynamic_json#test.test_jdoc('nested'), '.my_shapes')
/

/*
design--6.2-dynamic_json_unpivot-test.sql

ROW#ID COLUMN#KEY COLUMN#VALUE        
------ ---------- --------------------
     1 color      blue                
     1 name       square              
     1 side       5                   
     2 length     5                   
     2 name       rectangle           
     2 width      3                   
     3 height     2                   
     3 length     5                   
     3 name       box                 
     3 width      3                   
     4 color      red                 
     4 name       hexagon             
     4 side       3                   
     5 name       circle              
     5 radius     3                   

15 rows selected. 


ROW#ID COLUMN#KEY COLUMN#VALUE        
------ ---------- --------------------
     1 color      blue                
     1 name       square              
     1 side       5                   
     2 length     5                   
     2 name       rectangle           
     2 width      3                   
     3 height     2                   
     3 length     5                   
     3 name       box                 
     3 width      3                   
     4 color      red                 
     4 name       hexagon             
     4 side       3                   
     5 name       circle              
     5 radius     3                   

15 rows selected. 



*/