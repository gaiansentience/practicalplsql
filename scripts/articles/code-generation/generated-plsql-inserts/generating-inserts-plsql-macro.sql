set pagesize 0;
set serveroutput on;
@create-load-table.sql

set feedback off
spool inserts-plsql-macro.sql

begin
    dbms_output.put_line(q'!
        variable bvStartScript varchar2(100)
        exec :bvStartScript := to_char(localtimestamp,'yyyy-mm-dd hh24:mi:ss.ff');
    !');
end;
/

with
function get_insert_calls(src_table in dbms_tf.table_t, tgt_table in dbms_tf.columns_t, rows_per_block in number default 10) return varchar2 sql_macro(table)
is
    l_cols varchar2(4000);
    l_params varchar2(4000);
    l_declare varchar2(4000);
    l_start_block varchar2(4000);
    l_end_block varchar2(4000);
    l_vals varchar2(4000);
    l_col_name varchar2(128);
    l_table varchar2(128) := tgt_table(1);-- src_table.table_name;
    l_col_typecode pls_integer;
    l_prefix varchar2(2);
begin
    for c in 1..src_table.column.count loop
        l_col_name := src_table.column(c).description.name;
        l_col_typecode := src_table.column(c).description.type;
        l_prefix := case when c > 1 then ', ' end;
        l_cols := l_cols || l_prefix || l_col_name;
        l_params := l_params || l_prefix || 'p_' || replace(l_col_name,'"');
        l_declare := l_declare || l_prefix || 'p_' || replace(l_col_name,'"') || ' in ' 
        || case l_col_typecode 
            when 1 then 'varchar2' 
            when 2 then 'number' 
            when 12 then 'date' 
            when 180 then 'timestamp'
            when 181 then 'timestamp with time zone'
            else 'typecode=' || l_col_typecode end || chr(10);
        l_vals := l_vals || '|| fmt(' || l_col_name || case when c = 1 then ', false' end || ')';
    end loop;
    
    l_start_block := '
declare
    procedure ins(' || l_declare || ') 
    is 
    begin
    insert into ' || l_table || '(
    ' || l_cols || '
    ) values (
    ' || l_params || '); 
    end ins;
begin
    ';
    l_end_block := '

commit;

end;
/
';
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

        select case when row# = 1 then '##START-BLOCK##' 
        when mod(row#, rows_per_block) = 0 then '##END-BLOCK## ##START-BLOCK##'
        end 
        || 'ins(' ##VALS## || ');' 
        || case when row# = rowcount# then '##END-BLOCK##' end
        as stmt 
        from (select rownum as row#, count(*) over () as rowcount#, s.* from src_table s) order by row#
        !'
        , '##VALS##',l_vals)
        , '##START-BLOCK##', l_start_block)
        , '##END-BLOCK##', l_end_block)
        ;
end get_insert_calls; 

select * 
from get_insert_calls(test_staging, columns(test_target),100);
/

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

@inserts-plsql-macro.sql

set feedback on
