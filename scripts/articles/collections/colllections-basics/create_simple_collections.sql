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

type pudt_id_nt is table of udt_id;
type pudt_id_aa is table of udt_id index by pls_integer;
type pudt_id_av is table of udt_id index by array_index;
type pudt_id_v10 is varray(10) of udt_id;

function get_rows_nt(l_rows in number) return rec_id_nt pipelined;

function get_rows_pudt(l_rows in number) return pudt_id_nt pipelined;

function get_rows_udt(l_rows in number) return udt_id_nt pipelined;

end package_types;
/

create or replace package body package_types 
as

function get_rows_nt(l_rows in number) return rec_id_nt pipelined
is 
cursor c is
select level as id connect by level <= l_rows;
begin
    for r in c loop
        pipe row (r.id);
    end loop;
    
end get_rows_nt;

function get_rows_pudt(l_rows in number) return pudt_id_nt pipelined
is 
cursor c is
select level as id connect by level <= l_rows;
begin
    for r in c loop
        pipe row ( udt_id(r.id) );
    end loop;
    
end get_rows_pudt;

function get_rows_udt(l_rows in number) return udt_id_nt pipelined
is 
cursor c is
select level as id connect by level <= l_rows;
begin
    for r in c loop
        pipe row ( udt_id(r.id) );
    end loop;
    
end get_rows_udt;

end package_types;
/

