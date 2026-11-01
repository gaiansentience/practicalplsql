alter session disable parallel dml;
alter session set statistics_level = all;
--iterative development harness for cursor procedure
--set autotrace on;
set serveroutput on;
declare
    type type_test_record is record(
        usecase varchar2(100)
        , fingerprint varchar2(100), sqlid varchar2(100)
        , module varchar2(100), action varchar2(100)
        , rowscount number, rowshash number
        , started timestamp, ended timestamp, duration dsinterval_unconstrained);
    type type_test_nt is table of type_test_record;
    l_all_tests type_test_nt := type_test_nt();    
    --create record and table type for cursor
    type type_cursor_rec is record(id number, value varchar2(4000));
    type type_cursor_nt is table of type_cursor_rec;
    
    function get_sqlid(f in varchar2, m in varchar2, a in varchar2) return varchar2
    is
        id varchar2(100);
    begin
        select sql_id into id
        from v$sql where instr(sql_text,f) > 0 and module = m and action = a
        order by last_load_time desc
        fetch first row only;
        
        return id;
    exception
    when others then return null;
    end get_sqlid;

    procedure print_heading(s in varchar2)
    is
    begin
        dbms_output.put_line(
            lpad('*', 20, '*')
            || s
            || lpad('*', 80, '*')
        );
    end print_heading;

    procedure dump_plan(sqlid in varchar2)
    is
        type vc_tab is table of varchar2(4000);
        l_plan vc_tab;
        
    begin
        select plan_table_output
        bulk collect into l_plan
        from dbms_xplan.display_cursor(sqlid, format => 'ALL ALLSTATS PROJECTION NOTE');
        print_heading('Execution Plan for ' || sqlid);
        for v in values of l_plan loop
            dbms_output.put_line(v);
        end loop;
        
    end dump_plan;
    
    procedure print_results
    is
    lf constant varchar2(1) := chr(10);
    type xplans is table of boolean index by varchar2(100);
    x xplans;
    begin
        for v in values of l_all_tests loop
        print_heading(v.usecase);
            dbms_output.put_line(
                v.usecase || lf
                || 'sql_id: ' || v.sqlid || lf
                || 'rows: ' || v.rowscount || lf
                || 'rowshash: ' || v.rowshash || lf
                || 'duration: ' || to_char(v.duration)
                );
                
        end loop;
        
        print_heading('Unique Execution Plans');
        for v in values of l_all_tests  when v.sqlid is not null loop
            x(v.sqlid) := true;
        end loop;
        for idx in indices of x loop
            dump_plan(idx);
        end loop;

    end print_results;
    
    function simple_hash(p_tag in varchar2, p_value in varchar2) return number
    is
    begin
        return dbms_utility.get_hash_value(p_tag || p_value, 1, power(2, 22));
    end simple_hash;
    function clob_hash(p_tag in varchar2, p_value in clob) return number
    is
    hsh varchar2(1000);
    begin
        hsh := dbms_crypto.hash(p_value, 4);
        return simple_hash(p_tag, hsh);
    end clob_hash;
    
    function row_hash(rownum in number, r in type_cursor_rec) return number
    is
    begin
        return
            simple_hash('row',
                simple_hash('rownum', rownum)
                || simple_hash('id', r.id)
                || simple_hash('value', r.value)
            );
    end row_hash;
    
    function rows_hash(t in type_cursor_nt) return number
    is
        n number := 0;
    begin
        for i,v in pairs of t loop
            n := n + row_hash(i,v);
        end loop;
        return n;
    end rows_hash;
    

    function start_test(u in varchar2, f in varchar2, a in varchar2) return type_test_record
    is
    begin
        dbms_application_info.set_module('optimizeCursor',a);
        return type_test_record(usecase => u, fingerprint => f, module => 'optimizeCursor', action => a, started => localtimestamp);
    end start_test;
    
    procedure end_test(t in out type_test_record, r in type_cursor_nt)
    is
    begin
        dbms_application_info.set_module(null,null);
        t.ended := localtimestamp;
        t.duration := t.ended - t.started;
        t.sqlid := get_sqlid(t.fingerprint, t.module, t.action);
        t.rowscount := r.count;
        t.rowshash := rows_hash(r);
        l_all_tests.extend;
        l_all_tests(l_all_tests.last) := t;
    end end_test;

    procedure current_procedure (p0 in number, rc out sys_refcursor)
    is
    begin
        --code for current procedure
        --add fingerprint comment to locate sqlid easily
        open rc for
        with n_base as (
            select level as id
            connect by level <= p0
        )
        select /*+ monitor C101_CURRENT */
        id, 'item ' || id as value
        from n_base;

    end current_procedure;
        
    procedure variant1 (p0 in number, rc out sys_refcursor)
    is
    begin

        --code for variant procedure
        --add fingerprint comment to locate sqlid easily
        open rc for
        with r(id, value, lvl) as (
        select 1, 'item 1', 1
        union all
        select r.id + 1, 'item ' || (r.id + 1), r.lvl + 1
        from r
        where r.lvl < p0
        )
        select /*+ monitor C101_VARIANT_01 */
            id, value
        from r;    

    end variant1;

    procedure variant2 (p0 in number, rc out sys_refcursor)
    is
    begin

        --code for variant procedure
        --add fingerprint comment to locate sqlid easily
        open rc for
        select /*+ monitor C101_VARIANT_02 */
            id, value
        from (
            with r(id, value, lvl) as (
            select 1, 'item 1', 1
            union all
            select r.id + 1, 'item ' || (r.id + 1), r.lvl + 1
            from r
            where r.lvl < p0
            )
            select id, value
            from r);    

    end variant2;

    
    procedure run_test(p0 in number)
    is
    l_test type_test_record;
    rc sys_refcursor;
    t type_cursor_nt;
    begin
        l_test := start_test('current', 'C101_CURRENT', '1.01c');
        current_procedure(p0, rc);
        fetch rc bulk collect into t;
        end_test(l_test, t);
        
        l_test := start_test('variant-1', 'C101_VARIANT_01', '1.01v1');
        variant1(p0, rc);
        fetch rc bulk collect into t;
        end_test(l_test, t);
        
        l_test := start_test('variant-2', 'C101_VARIANT_02', '1.01v2');
        variant2(p0, rc);
        fetch rc bulk collect into t;
        end_test(l_test, t);
        
    end run_test;
        
begin

    run_test(5);
    run_test(50);
    
    print_results;


end;
/

