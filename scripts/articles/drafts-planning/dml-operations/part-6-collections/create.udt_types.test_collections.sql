
create type if not exists udt_id_obj as object(id number)
/

create type if not exists udt_id_obj_nt as table of udt_id_obj
/

create type if not exists udt_number_nt is table of number
/

