set pagesize 0;

@create-load-table.sql

set feedback off
spool inserts-sql.sql

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


select 'insert into test_target(id, n_val, s_val, d_val, ts_val, tstz_val) values ('
    || fmt(id,false) || fmt(n_val) || fmt(s_val) || fmt(d_val) || fmt(ts_val) || fmt(tstz_val)
    || ');' as stmt
from test_staging
/


spool off
set feedback on