prompt design--8.2-enhancements-test.sql

column row#id format 9
column column#key format a10
column column#value format a20
set pagesize 100

prompt simple json with no row identifier
select *
from dynamic_json#beta.unpivot_json_array(dynamic_json#test.test_jdoc('simple'))
/

prompt simple json with shape_id as row identifier
select *
from dynamic_json#beta.unpivot_json_array(dynamic_json#test.test_jdoc('simple_id'), row_identifier => 'shape_id')
/

prompt nested json with no row identifier
select *
from dynamic_json#beta.unpivot_json_array(dynamic_json#test.test_jdoc('nested'), array_path => '.my_shapes')
/

prompt nested json with shape_id as row identifier
select *
from dynamic_json#beta.unpivot_json_array(dynamic_json#test.test_jdoc('nested_id'), row_identifier => 'shape_id', array_path => '.my_shapes')
/

/*
design--8.2-enhancements-test.sql
simple json with no row identifier

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

simple json with shape_id as row identifier

ROW#ID COLUMN#KEY COLUMN#VALUE        
------ ---------- --------------------
   101 color      blue                
   101 name       square              
   101 side       5                   
   102 length     5                   
   102 name       rectangle           
   102 width      3                   
   103 height     2                   
   103 length     5                   
   103 name       box                 
   103 width      3                   
   104 color      red                 
   104 name       hexagon             
   104 side       3                   
   105 name       circle              
   105 radius     3                   

15 rows selected. 

nested json with no row identifier

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

nested json with shape_id as row identifier

ROW#ID COLUMN#KEY COLUMN#VALUE        
------ ---------- --------------------
   101 color      blue                
   101 name       square              
   101 side       5                   
   102 length     5                   
   102 name       rectangle           
   102 width      3                   
   103 height     2                   
   103 length     5                   
   103 name       box                 
   103 width      3                   
   104 color      red                 
   104 name       hexagon             
   104 side       3                   
   105 name       circle              
   105 radius     3                   

15 rows selected. 


*/