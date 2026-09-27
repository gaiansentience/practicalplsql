
create or replace package body package_types 
as

function get_rows_nt(l_rows in number) return rec_id_nt pipelined
is 
cursor c is
select level as id connect by level <= l_rows;
begin
    for r in c loop
        pipe row (r);
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

