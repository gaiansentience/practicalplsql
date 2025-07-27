create table if not exists recipes (
    id number 
        generated always as identity 
        constraint recipes_pk primary key
    , name varchar2(100 char) 
        constraint recipes_nn_name not null 
        constraint recipes_u_name unique
    , doc varchar2(4000 char)  
    , created_by varchar2(100 char) default user
    , created_date date default sysdate
    , updated_by varchar2(100 char)
    , updated_date date    
)
/
