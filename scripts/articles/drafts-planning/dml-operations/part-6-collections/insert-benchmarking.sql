alter session disable parallel dml ;


spool ./insert-benchmarking.txt

/*

pkg_coll -> insert-select-table(coll)



procedure insert_direct(base_rows in pkg_collection)
is
begin

insert into destination_table
select
from table(base_rows)
join other_rows



pkg_coll -> odci_coll -> insert - select - pipelined(select table(odci-coll))


function get_rows(base_rows in odci_varchar)
return row_collection pipelined

cursor more_rows is
select
from table(base_rows)
join other_rows

for r in more_rows loop
    pipe row (r)
end loop


procedure insert_more(base_rows in pkg_collection)
is
l_base_rows;
begin

select *
bulk collect into l_base_rows
from table(base_rows)

insert into destination_table
select *
from get_rows(l_base_rows);

*/

set serveroutput on;

create table if not exists test_insert_collection(
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
    type t_test_rec is record (
        test_records number,
        test_duration interval day to second(9),
        test_name varchar2(100)
        );
    type t_test_nt is table of t_test_rec;
    
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

    procedure start_test(test_name in varchar2);
    
    procedure stop_test;
    
    procedure show_errors;
    
    procedure show_results;
    
    procedure set_limit(bulk_limit in number default g_bulk_limit);
    
    function get_limit return number;
    
    procedure initialize_tests(number_records in number default g_test_records);
    
    function get_records return number;
    
end pkg_test;
/

create or replace package body pkg_test as

    g_start_test timestamp;
    g_test varchar2(100);
    
    g_results t_test_nt := t_test_nt();
    
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
    
    procedure p(msg in varchar2)
    is
    begin
        dbms_output.put_line(msg);
    end p;
        
    procedure start_test(test_name in varchar2)
    is
    begin
        g_test := test_name;
        g_start_test := localtimestamp;
    end start_test;
    
    procedure submit_results(test_duration in dsinterval_unconstrained, test_name in varchar2)
    is
        r t_test_rec;
    begin
        r := t_test_rec(g_test_records, test_duration, test_name);
        g_results.extend;
        g_results(g_results.last) := r;

    end submit_results; 
    
    procedure stop_test
    is
        l_duration dsinterval_unconstrained;
    begin
        l_duration := localtimestamp - g_start_test;
        p(to_char(l_duration) 
            || ', records=' || g_test_records
            || ', test: ' || g_test);
        submit_results(l_duration, g_test);
    end stop_test;
    
    procedure show_results
    is
    begin
        for i,v in pairs of (
            select b.test_duration, b.test_records, b.test_name
                , round(best/test_duration_seconds,4) * 100 || '%' as ratio_to_best
                , round(worst/test_duration_seconds,4) * 100 || '%' as ratio_to_worst
            from 
                (
                select 
                    test_duration
                    , extract(second from test_duration) as test_duration_seconds
                    ,test_records, test_name
                    , extract(second from min(test_duration) over ()) as best
                    , extract(second from max(test_duration) over ()) as worst
                from table(g_results) 
                ) b
            order by b.test_duration
        ) loop
            p(i || ' => ' || to_char(v.test_duration) || ', ' || v.test_records || ', ' || v.test_name
                || ', ratio to best: ' || v.ratio_to_best
                || ', ratio to worst: ' || v.ratio_to_worst);
        end loop;
    end show_results;
    
    procedure show_errors
    is
    begin
        p('Errors: ' || g_test || ' ' || sqlerrm);
    end show_errors;

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
        execute immediate 'truncate table test_insert_collection drop storage';
        execute immediate 'truncate table test_source_records drop storage';
        --allocate space for test records
        insert into test_insert_collection
        select level
        connect by level <= g_test_records;
        insert into test_source_records
        select id 
        from test_insert_collection;
        commit;
        --clear test table, keep allocated space
        execute immediate 'truncate table test_insert_collection';
    end initialize_tests;
    
    function get_records return number
    is
    begin
        return g_test_records;
    end get_records;

end pkg_test;
/

set feedback off;

begin
    pkg_test.initialize_tests(1000000);
end;
/

declare
begin
    pkg_test.start_test('***INSERT SELECT SQL BASELINE***');
    
    insert into test_insert_collection(id)
    select id
    from test_source_records
    where rownum < pkg_test.get_records();
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/

declare
begin
    pkg_test.start_test('***INSERT CURSOR LOOP PLSQL BASELINE***');
    
    for r in (
        select id 
        from test_source_records
        where rownum < pkg_test.get_records()
    ) loop
        insert into test_insert_collection(id)
        values (r.id);
    end loop;
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/


declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;

    pkg_test.start_test('***INSERT COLLECTION LOOP PLSQL BASELINE***');
    
    for i in 1..l_ids.count loop
        insert into test_insert_collection(id)
        values (l_ids(i));
    end loop;

    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/
    

declare
    l_ids pkg_test.t_id_rec_nt;
begin
    l_ids := pkg_test.get_package_record_nt;
    
    pkg_test.start_test('insert select *** TABLE(c)*** package nested table of record');
        
    insert into test_insert_collection(id)
    select t.id from table(l_ids) t;

    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/

declare
    l_ids pkg_test.t_id_rec_nt;
begin
    l_ids := pkg_test.get_package_record_nt;

    pkg_test.start_test('insert values ***FORALL*** package nested table of record');

    forall i in indices of l_ids
    insert into test_insert_collection(id)
    values (l_ids(i).id);

    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/


declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;

    pkg_test.start_test('insert select *** TABLE(c)*** package nested table of number');
        
    insert into test_insert_collection(id)
    select t.column_value from table(l_ids) t;

    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/

declare
    l_ids pkg_test.t_number_nt;
begin
    l_ids := pkg_test.get_package_number_nt;
    
    pkg_test.start_test('insert values ***FORALL*** package nested table of number');
    
    forall i in indices of l_ids
    insert into test_insert_collection(id)
    values (l_ids(i));
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/


declare
    l_ids udt_id_obj_nt;
begin
    l_ids := pkg_test.get_udt_object_nt;
    
    pkg_test.start_test('insert select *** TABLE(c)*** nested table of object');
    
    insert into test_insert_collection(id)
    select t.id from table(l_ids) t;
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/

declare
    l_ids udt_id_obj_nt;
begin
    l_ids := pkg_test.get_udt_object_nt;
        
    pkg_test.start_test('insert values ***FORALL*** nested table of object');
    
    forall i in indices of l_ids
    insert into test_insert_collection(id)
    values (l_ids(i).id);
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
end;
/


declare
    l_ids udt_number_nt;
begin
    l_ids := pkg_test.get_udt_number_nt;
    
    pkg_test.start_test('insert select *** TABLE(c)*** nested table of number');
    
    insert into test_insert_collection(id)
    select t.column_value from table(l_ids) t;
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
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

    pkg_test.start_test('insert values ***FORALL*** nested table of number');
    
    forall i in indices of l_ids
    insert into test_insert_collection(id)
    values (l_ids(i));
    
    pkg_test.stop_test;
    rollback;
exception
    when others then
        pkg_test.show_errors;
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
    pkg_test.start_test('insert select *** TABLE(c)*** nested table of number bulk limit ' || pkg_test.get_limit);

    open c;    
    loop
    
        fetch c bulk collect into l_batch limit pkg_test.get_limit;        
        exit when l_batch.count = 0;
        
        insert into test_insert_collection(id)
        select t.column_value 
        from table(l_batch) t;
    
    end loop;
    close c;

    pkg_test.stop_test;
    rollback;

end loop test_limit_size;

exception
    when others then
        pkg_test.show_errors;
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
    pkg_test.start_test('insert values ***FORALL*** nested table of number bulk limit ' || pkg_test.get_limit);
        
    open c;
    loop
        fetch c bulk collect into l_batch limit pkg_test.get_limit;
        
        exit when l_batch.count = 0;
        
        forall i in indices of l_batch
        insert into test_insert_collection(id)
        values (l_batch(i));
    
    end loop;
    close c;

    pkg_test.stop_test;
    rollback;
    
end loop test_limit_size;

exception
    when others then
        pkg_test.show_errors;
end;
/

begin
    pkg_test.show_results;
end;
/

drop package pkg_test;
drop table if exists test_insert_collection purge;
drop table if exists test_source_records purge;
drop type if exists udt_number_nt;
drop type if exists udt_id_obj_nt;
drop type if exists udt_id_obj;

set feedback on;

spool off;