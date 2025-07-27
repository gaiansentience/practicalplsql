create table departments (
    id number generated always as identity 
        constraint departments_pk primary key
    , code varchar2(50) 
        constraint departments_code_required not null
        constraint departments_code_unique unique
        constraint departments_code_uppercase check (code = upper(code))
    , name varchar2(50) 
        constraint departments_name_required not null
        constraint departments_name_unique unique
    , description varchar2(100)
)
/
