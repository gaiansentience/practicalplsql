create or replace type udt_id as object(id number)
/

create or replace type udt_id_nt as table of udt_id
/

create or replace type udt_id_v10 as varray(10) of udt_id
/


create table if not exists test_types(id number);