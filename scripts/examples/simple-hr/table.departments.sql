create table departments (
    id number generated always as identity primary key
    , code varchar2(50) not null
        check (code = upper(code))
    , name varchar2(50) not null
    , description varchar2(100)
    , constraint departments_code_u unique (code)
);
/
