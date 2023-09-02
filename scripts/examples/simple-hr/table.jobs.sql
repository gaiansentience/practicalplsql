create table jobs (
    id number generated always as identity primary key
    , code varchar2(50) not null
        check (code = upper(code))
    , name varchar2(100) not null
    , description varchar2(100)
    , constraint jobs_code_u unique (code)
);
/
