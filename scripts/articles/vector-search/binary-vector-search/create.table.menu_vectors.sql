--create.table.menu_vectors.sql
--requires loaded menu_items table from examples/sample_foods menus example

describe menu_items;

drop table if exists menu_vectors purge
/

create table menu_vectors as 
select item_id
from menu_items
/

alter table menu_vectors add 
    constraint menu_vectors_pk 
    primary key (item_id)
/


alter table menu_vectors add(
    embedding vector(*,*)
    , embedding_model varchar2(50)
    , embedding_binary vector(*, binary)   
    , embedding1 vector(*,*)
    , embedding1_model varchar2(50)
    , embedding1_binary vector(*, binary)     
    , embedding2 vector(*,*)
    , embedding2_model varchar2(50)
    , embedding2_binary vector(*, binary)     
    , embedding3 vector(*,*)
    , embedding3_model varchar2(50)
    , embedding3_binary vector(*, binary)       
)
/

describe menu_vectors;

/*

Name             Null?    Type                
---------------- -------- ------------------- 
ITEM_ID          NOT NULL NUMBER(38)          
ITEM_NAME        NOT NULL VARCHAR2(100 CHAR)  
CATEGORY_ID               NUMBER(38)          
ITEM_DESCRIPTION          VARCHAR2(1000 CHAR) 
CREATED_BY                VARCHAR2(100 CHAR)  
CREATED_DATE              DATE                
UPDATED_BY                VARCHAR2(100 CHAR)  
UPDATED_DATE              DATE                

Table MENU_VECTORS dropped.


Table MENU_VECTORS created.


Table MENU_VECTORS altered.


Table MENU_VECTORS altered.

Name              Null?    Type                   
----------------- -------- ---------------------- 
ITEM_ID           NOT NULL NUMBER(38)             
EMBEDDING                  VECTOR(*,*,DENSE)      
EMBEDDING_MODEL            VARCHAR2(50)           
EMBEDDING_BINARY           VECTOR(*,BINARY,DENSE) 
EMBEDDING1                 VECTOR(*,*,DENSE)      
EMBEDDING1_MODEL           VARCHAR2(50)           
EMBEDDING1_BINARY          VECTOR(*,BINARY,DENSE) 
EMBEDDING2                 VECTOR(*,*,DENSE)      
EMBEDDING2_MODEL           VARCHAR2(50)           
EMBEDDING2_BINARY          VECTOR(*,BINARY,DENSE) 
EMBEDDING3                 VECTOR(*,*,DENSE)      
EMBEDDING3_MODEL           VARCHAR2(50)           
EMBEDDING3_BINARY          VECTOR(*,BINARY,DENSE) 
*/