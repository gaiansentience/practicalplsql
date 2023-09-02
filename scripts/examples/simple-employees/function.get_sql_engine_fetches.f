--grant select on v_$sqlarea to practicalplsql;
create or replace function get_sql_engine_fetches(
    l_sql_seed in varchar2
    ) return number
is
    l_fetches number;
begin

    select sum(fetches) into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, l_sql_seed) > 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    return l_fetches;
exception
    when others then
        return 0;
end get_sql_engine_fetches;
/
