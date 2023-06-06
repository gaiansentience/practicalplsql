declare
    cursor c_names is
    with base as
    (
        select 'Albert Einstein' as full_name from dual union all
        select 'Marie Curie' from dual union all
        select 'Maya Angelou' from dual union all
        select 'Rosa Parks' from dual
    ), first_names as
    (
        select substr(full_name, 1, instr(full_name, ' ') - 1) as f_name
        from base
    ), last_names as
    (
        select substr(full_name, instr(full_name, ' ') + 1) as l_name
        from base
    )
    select f.f_name, l.l_name
    from 
        first_names f
        cross join last_names l;
begin
    for r in c_names loop
        dbms_output.put_line(r.f_name || ' ' || r.l_name);
    end loop;    
end;
/