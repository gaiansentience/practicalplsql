set pagesize 0;

@create-load-table.sql

set feedback off
spool inserts-plsql.sql

with

function start_block(p_row in number) return varchar2
is
    l_ret varchar2(4000);
begin
        l_ret := '
declare
    procedure ins(p_id in number, p_n_val in number, p_s_val in varchar2, p_d_val in date, p_ts_val in timestamp, p_tstz_val in timestamp with time zone)
    is
    begin
        insert into test_target(id, n_val, s_val, d_val, ts_val, tstz_val)
        values (p_id, p_n_val, p_s_val, p_d_val, p_ts_val, p_tstz_val);
    end ins;
begin
    dbms_output.put_line(''starting block with row ' || p_row  || ''');
    
';
    return l_ret;
end start_block;

function end_block return varchar2
is
l_ret varchar2(4000);
begin
        l_ret := q'!
commit;
end;
/
!';
    return l_ret;
end end_block;
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

select 
    case when b.row# = 1 then start_block(b.row#) 
        when mod(b.row#,5) = 0 then end_block() || start_block(b.row#) end
    || 'ins(' || fmt(b.id,false) || fmt(b.n_val) || fmt(b.s_val) || fmt(b.d_val) || fmt(b.ts_val) || fmt(b.tstz_val) || ');' 
    || case when b.row# = b.rowcount# then end_block() end as stmt
from 
    (
    select 
        rownum as row#
        , count(*) over () as rowcount#
        , s.*
    from test_staging s
    ) b
order by b.row#
/

spool off
set feedback on