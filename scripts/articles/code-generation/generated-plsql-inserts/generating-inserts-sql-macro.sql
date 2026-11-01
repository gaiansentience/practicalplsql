set pagesize 0;
set serveroutput on;

@create-load-table.sql

set feedback off
spool inserts-sql-macro.sql

begin
    dbms_output.put_line(q'!
        variable bvStartScript varchar2(100)
        exec :bvStartScript := to_char(localtimestamp,'yyyy-mm-dd hh24:mi:ss.ff');
    !');
end;
/


exec dbms_output.put_line('alter session set cursor_sharing = force;');


with
function get_insert_statements(src_table in dbms_tf.table_t, tgt_table dbms_tf.columns_t) return varchar2 sql_macro(table)
is
    l_cols varchar2(4000);
    l_vals varchar2(4000);
    l_col varchar2(128);
begin
    for c in 1..src_table.column.count loop
        l_col := src_table.column(c).description.name;
        l_cols := l_cols || case when c > 1 then ',' end || l_col;
        l_vals := l_vals || '|| fmt('||l_col||case when c = 1 then ',false'end||')';
    end loop;
    return
    replace(replace(replace(
        q'!
with
    function comma(leading_comma in boolean default true) return varchar2
    is
    begin
        return case when leading_comma then ',' end;
    end comma;
    function fmt(n in number, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when n is null then 'null' else to_char(n) end;
    end fmt;
    function fmt(s in varchar2, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when s is null then 'null' else '''' || s || '''' end;
    end fmt;
    function fmt(d in date, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when d is null then 'null' 
                else 'to_date(''' || to_char(d, 'yyyy-mm-dd hh24:mi:ss') || ''',''yyyy-mm-dd hh24:mi:ss'')' end;
    end fmt;
    function fmt(t in timestamp, leading_comma in boolean default true) return varchar2
is
begin
return comma(leading_comma)
    || case when t is null then 'null' 
        else 'to_timestamp(''' || to_char(t, 'yyyy-mm-dd hh24:mi:ss.ff') || ''',''yyyy-mm-dd hh24:mi:ss.ff'')' end;
end fmt;
    function fmt(t in timestamp with time zone, leading_comma in boolean default true) return varchar2
is
begin
return comma(leading_comma)
    || case when t is null then 'null' 
        else 'to_timestamp_tz(''' || to_char(t, 'yyyy-mm-dd hh24:mi:ss.ff tzh:tzm') || ''',''yyyy-mm-dd hh24:mi:ss.ff tzh:tzm'')' end;
end fmt;


        select 'insert into ##TABLE## (##COLS##) VALUES('
        ##VALS##
        || ');' as stmt from src_table
        !'
        , '##COLS##', l_cols)
        , '##TABLE##', tgt_table(1)) --'test_target') --src_table.table_name)
        , '##VALS##',l_vals)
        ;
end get_insert_statements;        
select * from get_insert_statements(test_staging, columns(test_target));
/

exec dbms_output.put_line('commit;')

exec dbms_output.put_line('alter session set cursor_sharing = exact;');

begin
    dbms_output.put_line(q'!
    declare
        l_start timestamp;
    begin
        l_start := to_timestamp(:bvStartScript,'yyyy-mm-dd hh24:mi:ss.ff');
        dbms_output.put_line('Script duration: ' || to_char(localtimestamp - l_start));
    end;
    /
    !');
end;
/


spool off

@inserts-sql-macro.sql

set feedback on
