alter session disable parallel dml;

@create.tables.test_collections.sql
@create.udt_types.test_collections.sql
@create.package.test_timing_api.spec.sql
@create.package.test_timing_api.body.sql
@create.package.test_collections.spec.sql
@create.package.test_collections.body.sql

begin
    pkg_test.initialize_tests(100000);
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
    
    test_timing_api.start_test('insert ***select table(c)*** package nested table of record', pkg_test.get_records);
        
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

    test_timing_api.start_test('insert ***values forall*** package nested table of record', pkg_test.get_records);

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

    test_timing_api.start_test('insert ***select table(c)*** package nested table of number', pkg_test.get_records);
        
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
    
    test_timing_api.start_test('insert ***values forall*** package nested table of number', pkg_test.get_records);
    
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
    
    test_timing_api.start_test('insert ***select table(c)*** nested table of object', pkg_test.get_records);
    
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
        
    test_timing_api.start_test('insert ***values forall*** nested table of object', pkg_test.get_records);
    
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
    
    test_timing_api.start_test('insert ***select table(c)*** nested table of number', pkg_test.get_records);
    
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

    test_timing_api.start_test('insert ***values forall*** nested table of number', pkg_test.get_records);
    
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
    test_timing_api.start_test('insert ***select table(c)*** nested table of number bulk limit ' || pkg_test.get_limit, pkg_test.get_records);

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
    test_timing_api.start_test('insert ***values forall*** nested table of number bulk limit ' || pkg_test.get_limit, pkg_test.get_records);
        
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

@drop.objects.test_collections.sql