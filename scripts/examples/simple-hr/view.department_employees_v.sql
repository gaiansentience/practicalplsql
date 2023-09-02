create table employees (
    id number generated always as identity primary key
    , name varchar2(50)
    , job varchar2(50)
);
/