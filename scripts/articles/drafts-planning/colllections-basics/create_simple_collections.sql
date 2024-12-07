create or replace type udt_id as object(id number)
/

create or replace type udt_id_nt as table of udt_id
/

create or replace type udt_id_v10 as varray(10) of udt_id
/

create or replace package package_types
as

subtype array_index is varchar2(100);

type rec_id is record(id number);

type rec_id_nt is table of rec_id;
type rec_id_aa is table of rec_id index by pls_integer;
type rec_id_aav is table of rec_id index by array_index;
type rec_id_v10 is varray(10) of rec_id;

type udt_id_nt is table of udt_id;
type udt_id_aa is table of udt_id index by pls_integer;
type udt_id_av is table of udt_id index by array_index;
type udt_id_v10 is varray(10) of udt_id;

end package_types;
/

