create table locations (
    id number generated always as identity primary key
    , code varchar2(50) not null
        check (code = upper(code))
    , name varchar2(100) not null
    , description varchar2(100)
    , address varchar2(100)
    , city varchar2(100)
    , constraint locations_code_u unique (code)
);
/
