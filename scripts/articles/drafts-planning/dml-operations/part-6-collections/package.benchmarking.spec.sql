
create table if not exists test_dest_records(
id number)
/

create table if not exists test_source_records(
id number)
/

create type udt_id_obj as object(id number)
/

create type udt_id_obj_nt as table of udt_id_obj
/

create type udt_number_nt is table of number
/

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

set feedback on;

begin
    pkg_test.initialize_tests(1000);
    test_timing_api.initialize;
end;
/

declare
begin
    test_timing_api.start_test('***INSERT SELECT SQL BASELINE***', pkg_test.get_records);
    
    insert into test_dest_records(id)
    select id
    from test_source_records
    where rownum < pkg_test.get_records();
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
begin
    test_timing_api.start_test('***INSERT CURSOR LOOP PLSQL BASELINE***', pkg_test.get_records);
    
    for r in (
        select id 
        from test_source_records
        where rownum < pkg_test.get_records()
    ) loop
        insert into test_dest_records(id)
        values (r.id);
    end loop;
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/


declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;

    test_timing_api.start_test('***INSERT COLLECTION LOOP PLSQL BASELINE***', pkg_test.get_records);
    
    for i in 1..l_ids.count loop
        insert into test_dest_records(id)
        values (l_ids(i));
    end loop;

    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/
    

declare
    l_ids pkg_test.t_id_rec_nt;
begin
    l_ids := pkg_test.get_package_record_nt;
    
    test_timing_api.start_test('insert select *** TABLE(c)*** package nested table of record', pkg_test.get_records);
        
    insert into test_dest_records(id)
    select t.id from table(l_ids) t;

    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
    l_ids pkg_test.t_id_rec_nt;
begin
    l_ids := pkg_test.get_package_record_nt;

    test_timing_api.start_test('insert values ***FORALL*** package nested table of record', pkg_test.get_records);

    forall i in indices of l_ids
    insert into test_dest_records(id)
    values (l_ids(i).id);

    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/


declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;

    test_timing_api.start_test('insert select *** TABLE(c)*** package nested table of number', pkg_test.get_records);
        
    insert into test_dest_records(id)
    select t.column_value from table(l_ids) t;

    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;
    
    test_timing_api.start_test('insert values ***FORALL*** package nested table of number', pkg_test.get_records);
    
    forall i in indices of l_ids
    insert into test_dest_records(id)
    values (l_ids(i));
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/


declare
    l_ids udt_id_obj_nt;
begin
    l_ids := pkg_test.get_udt_object_nt;
    
    test_timing_api.start_test('insert select *** TABLE(c)*** nested table of object', pkg_test.get_records);
    
    insert into test_dest_records(id)
    select t.id from table(l_ids) t;
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
    l_ids udt_id_obj_nt;
begin
    l_ids := pkg_test.get_udt_object_nt;
        
    test_timing_api.start_test('insert values ***FORALL*** nested table of object', pkg_test.get_records);
    
    forall i in indices of l_ids
    insert into test_dest_records(id)
    values (l_ids(i).id);
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/


declare
    l_ids udt_number_nt;
begin
    l_ids := pkg_test.get_udt_number_nt;
    
    test_timing_api.start_test('insert select *** TABLE(c)*** nested table of number', pkg_test.get_records);
    
    insert into test_dest_records(id)
    select t.column_value from table(l_ids) t;
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
    l_ids udt_number_nt;
    l_batch udt_number_nt;

    cursor c is 
    select t.column_value as id 
    from table(l_ids) t;
begin
    l_ids := pkg_test.get_udt_number_nt;

    test_timing_api.start_test('insert values ***FORALL*** nested table of number', pkg_test.get_records);
    
    forall i in indices of l_ids
    insert into test_dest_records(id)
    values (l_ids(i));
    
    test_timing_api.stop_test;
    rollback;
exception
    when others then
        test_timing_api.print_error;
end;
/

declare
    l_ids udt_number_nt;
    l_batch udt_number_nt;

    cursor c is 
    select t.column_value as id 
    from table(l_ids) t;
begin
    l_ids := pkg_test.get_udt_number_nt;

<<test_limit_size>>    
for batch_limit in 100, 1000, 10000, 100000 loop

    pkg_test.set_limit(batch_limit);
    test_timing_api.start_test('insert select *** TABLE(c)*** nested table of number bulk limit ' || pkg_test.get_limit, pkg_test.get_records);

    open c;    
    loop
    
        fetch c bulk collect into l_batch limit pkg_test.get_limit;        
        exit when l_batch.count = 0;
        
        insert into test_dest_records(id)
        select t.column_value 
        from table(l_batch) t;
        
        exit when c%notfound;
    
    end loop;
    close c;

    test_timing_api.stop_test;
    rollback;

end loop test_limit_size;

exception
    when others then
        test_timing_api.print_error;
end;
/


declare
    l_ids udt_number_nt;
    l_batch udt_number_nt;

    cursor c is 
    select t.column_value as id 
    from table(l_ids) t;    
begin
    l_ids := pkg_test.get_udt_number_nt;
    
<<test_limit_size>>    
for batch_limit in 100, 1000, 10000, 100000 loop

    pkg_test.set_limit(batch_limit);
    test_timing_api.start_test('insert values ***FORALL*** nested table of number bulk limit ' || pkg_test.get_limit, pkg_test.get_records);
        
    open c;
    loop
        fetch c bulk collect into l_batch limit pkg_test.get_limit;
        
        exit when l_batch.count = 0;
        
        forall i in indices of l_batch
        insert into test_dest_records(id)
        values (l_batch(i));
        
        exit when c%notfound;
    
    end loop;
    close c;

    test_timing_api.stop_test;
    rollback;
    
end loop test_limit_size;

exception
    when others then
        test_timing_api.print_error;
end;
/

begin
    test_timing_api.print_results;
end;
/

drop package pkg_test;
drop table if exists test_dest_records purge;
drop table if exists test_source_records purge;
drop type if exists udt_number_nt;
drop type if exists udt_id_obj_nt;
drop type if exists udt_id_obj;

set feedback on;

spool off;