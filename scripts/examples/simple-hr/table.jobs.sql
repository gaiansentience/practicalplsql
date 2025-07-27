create table jobs (
    id number generated always as identity 
        constraint jobs_pk primary key
    , code varchar2(50) 
        constraint jobs_code_required not null
        constraint jobs_code_unique unique
        constraint jobs_code_uppercase check (code = upper(code))
    , name varchar2(100) 
        constraint jobs_name_required not null
        constraint jobs_name_unique unique
    , description varchar2(100)
)
/
