

create or replace package pkg_test as

    type t_id_rec    is record(id number);
    type t_id_rec_nt is table of t_id_rec;
    type t_number_nt is table of number;
    type t_id_obj_nt is table of udt_id_obj;
    
    g_bulk_limit number := 100;
    g_test_records number := 1000;
    
    

    --get functions for different collection types    
    function get_package_record_nt(n in number default g_test_records
    ) return pkg_test.t_id_rec_nt;
    
    function get_package_number_nt(n in number default g_test_records
    ) return pkg_test.t_number_nt;
    
    function get_udt_object_nt(n in number default g_test_records
    ) return udt_id_obj_nt;

    function get_udt_number_nt(n in number default g_test_records
    ) return udt_number_nt;
    
    procedure set_limit(bulk_limit in number default g_bulk_limit);
    
    function get_limit return number;
    
    procedure initialize_tests(number_records in number default g_test_records);
    
    function get_records return number;
    
end pkg_test;
/

