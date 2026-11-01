drop type if exists udt_id_v10;
drop type if exists udt_id_nt;

create or replace type udt_id as object(id number)
/

create or replace type udt_id_nt as table of udt_id
/

create or replace type udt_id_v10 as varray(10) of udt_id
/

