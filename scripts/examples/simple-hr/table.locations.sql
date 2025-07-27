create table locations (
    id number generated always as identity 
        constraint locations_pk primary key
    , code varchar2(50)
        constraint locations_code_required not null
        constraint locations_code_unique unique
        constraint locations_code_uppercase check (code = upper(code))
    , name varchar2(100) 
        constraint locations_name_required not null
        constraint locations_name_unique unique
    , description varchar2(100)
    , address varchar2(100)
    , city varchar2(100)
)
/
