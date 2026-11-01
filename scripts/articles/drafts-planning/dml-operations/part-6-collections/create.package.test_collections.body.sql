create or replace package body pkg_test as

    g_ids pkg_test.t_id_rec_nt;
    
    --get functions for different collection types    
    function get_package_record_nt(n in number default g_test_records
    ) return pkg_test.t_id_rec_nt
    is
        l_ids pkg_test.t_id_rec_nt;
    begin
        g_test_records := n;

        select id
        bulk collect into l_ids
        from test_source_records
        where rownum < n;
        
        return l_ids;
    end get_package_record_nt;
    
    function get_package_number_nt(n in number default g_test_records
    ) return pkg_test.t_number_nt
    is
        l_ids pkg_test.t_number_nt;
    begin
        g_test_records := n;
        
        select id
        bulk collect into l_ids
        from test_source_records
        where rownum < n;

        return l_ids;
    end get_package_number_nt;
    
    function get_udt_object_nt(n in number default g_test_records
    ) return udt_id_obj_nt
    is
        l_ids udt_id_obj_nt;
    begin
        g_test_records := n;
        
        select udt_id_obj(id)
        bulk collect into l_ids
        from test_source_records
        where rownum < n;

        return l_ids;
    end get_udt_object_nt;
    
    function get_udt_number_nt(n in number default g_test_records
    ) return udt_number_nt
    is
        l_ids udt_number_nt;
    begin
        g_test_records := n;
        
        select id
        bulk collect into l_ids
        from test_source_records
        where rownum < n;

        return l_ids;
    end get_udt_number_nt;
    
    procedure set_limit(bulk_limit in number default g_bulk_limit)
    is
    begin
        g_bulk_limit := bulk_limit;
    end set_limit;
    
    function get_limit return number
    is
    begin
        return g_bulk_limit;
    end get_limit;

    procedure initialize_tests(number_records in number default g_test_records)
    is
    begin
        g_test_records := number_records;
        --clear storage for test table
        execute immediate 'truncate table test_dest_records drop storage';
        execute immediate 'truncate table test_source_records drop storage';
        --allocate space for test records
        insert into test_dest_records
        select level
        connect by level <= g_test_records;
        insert into test_source_records
        select id 
        from test_dest_records;
        commit;
        --clear test table, keep allocated space
        execute immediate 'truncate table test_dest_records';
    end initialize_tests;
    
    function get_records return number
    is
    begin
        return g_test_records;
    end get_records;

end pkg_test;
/
